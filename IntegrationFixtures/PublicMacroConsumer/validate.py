#!/usr/bin/env python3
"""Build/run the public macro fixture, expected failures, and actual host/runtime boundaries."""
import argparse, datetime, json, pathlib, platform, re, shutil, subprocess, sys

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--output', type=pathlib.Path, required=True)
args = parser.parse_args()
fixture = pathlib.Path(__file__).resolve().parent
out = args.output.resolve()
out.mkdir(parents=True, exist_ok=False)
scratch = out / 'build'
record = {'commands': [], 'startedAt': datetime.datetime.now(datetime.timezone.utc).isoformat()}
def save():
    (out / 'validation.json').write_text(json.dumps(record, indent=2) + '\n')
def run(argv, label, expected_failure=False):
    print(label, flush=True)
    with (out / (label + '.log')).open('w') as stdout, (out / (label + '.stderr')).open('w') as stderr:
        result = subprocess.run(argv, cwd=fixture, stdout=stdout, stderr=stderr)
    record['commands'].append(dict(argv=argv, exitCode=result.returncode, label=label, expectedFailure=expected_failure))
    save()
    if (result.returncode != 0) != expected_failure:
        sys.exit(f'{label} failed its expected outcome; see {out}')
    return (out / (label + '.log')).read_text(), (out / (label + '.stderr')).read_text()

if sys.platform != 'darwin': sys.exit('Required environment unavailable: macOS host with Swift 6.4 and Apple 27 SDKs.')
if not re.search(r'Swift version 6\.4(?:\.|\s)', run(['swift', '--version'], 'swift-version')[0]):
    sys.exit('Required Swift 6.4 toolchain unavailable.')
run(['sw_vers'], 'macos-version'); run(['xcodebuild', '-version'], 'xcode-version'); run(['xcodebuild', '-showsdks'], 'sdks')
run(['git', '-C', str(fixture.parent.parent), 'rev-parse', 'HEAD'], 'source-revision')
run(['git', '-C', str(fixture.parent.parent), 'status', '--short'], 'source-status')
for source in fixture.rglob('*.swift'):
    assert '@testable' not in source.read_text() and '@_spi' not in source.read_text(), source
options = ['--package-path', str(fixture), '--scratch-path', str(scratch)]
run(['swift', 'package', *options, 'resolve'], 'resolve')
run(['swift', 'package', *options, 'dump-package'], 'manifest')
dependencies = run(['swift', 'package', *options, 'show-dependencies', '--format', 'json'], 'dependencies')[0]
assert all(name not in dependencies for name in ['hdxl-macro-transflection-macros', 'hdxl-swift-accumulators']), dependencies
resolved = json.loads((fixture / 'Package.resolved').read_text())
syntax_pin = next(p for p in resolved['pins'] if p['identity'] == 'swift-syntax')
assert syntax_pin['state']['version'].split('.')[:1] == ['604'], syntax_pin
record['resolved'] = resolved
shutil.copy2(fixture / 'Package.resolved', out / 'Package.resolved')
run(['swift', 'build', *options, '-v'], 'build')
run(['swift', 'test', *options], 'test')
assert 'Public macro consumer passed.' in run(['swift', 'run', *options, '--skip-build', 'FixtureClient'], 'client')[0]
bin_path = pathlib.Path(run(['swift', 'build', *options, '--show-bin-path'], 'bin-path')[0].strip())
sdk = run(['xcrun', '--sdk', 'macosx', '--show-sdk-path'], 'sdk-path')[0].strip()
compiler = ['swiftc', '-swift-version', '6', '-sdk', sdk, '-target', platform.machine() + '-apple-macosx27.0']

# Real compiler rejection fixtures are separate from the successful build and host expansion tests.
plugin = bin_path / 'FixturePlugin'
assert plugin.is_file(), plugin
for file, line, text in [
    ('UnsupportedMember', 6, 'Unsupported fixture member: lazyBinding'),
    ('WrappedMember', 9, 'Unsupported fixture member: attributedBinding'),
    ('Collision', 7, 'A member conflicts with a planned fixture name.'),
    ('UnsupportedExpression', 8, 'Invalid fixture options.')
]:
    _, stderr = run([*compiler, '-module-cache-path', str(out / 'compiler-cache'), '-I', str(bin_path), '-load-plugin-executable', str(plugin) + '#FixturePlugin',
                     '-typecheck', str(fixture / 'CompilerChecks' / (file + '.swift'))],
                    'reject-' + file, expected_failure=True)
    primary = re.findall(r'^.*\.swift:\d+:\d+: error:.*$', stderr, re.M)
    assert len(primary) == 1, stderr
    assert sum(text in line for line in primary) == 1, stderr
    assert re.search(rf'{file}\.swift:{line}:\d+: error:.*{re.escape(text)}', stderr), stderr
    assert not any(s in stderr for s in ['plugin not found', 'failed to load', 'no such module', 'SDK not found']), stderr
    if file == 'UnsupportedExpression':
        assert all(s in stderr for s in ['macro argument 0', 'items', 'array element 1']), stderr
    record.setdefault('expectedDiagnostics', {})[file] = primary
    save()

pif = json.loads((scratch / 'manifest.pif').read_text())
shutil.copy2(scratch / 'manifest.pif', out / 'build-graph.pif')
targets = {x['contents']['guid']: x['contents'] for x in pif if x['type'] == 'target'}
def closure(name, skip_host=True):
    seen, host = set(), set()
    def visit(guid):
        target = targets[guid]
        if skip_host and target.get('productTypeIdentifier') == 'com.apple.product-type.tool.host-build':
            host.add(target['name']); return
        if guid in seen: return
        seen.add(guid)
        for dependency in target.get('dependencies', []): visit(dependency['guid'])
    start = 'PACKAGE-TARGET:' + name
    if start not in targets:
        # SwiftPM folds executable source into its product target and may give the separate
        # testable object target a configuration suffix. Inspect the actual executable product.
        matches = [guid for guid, target in targets.items()
                   if target['name'] == name + '-product'
                   and target.get('productTypeIdentifier') == 'com.apple.product-type.tool']
        assert len(matches) == 1, (name, matches)
        start = matches[0]
    visit(start)
    return sorted({targets[g]['name'] for g in seen}), sorted(host)
prefixes = ('SwiftSyntax', 'SwiftParser', 'SwiftDiagnostics', 'SwiftCompilerPlugin', 'SwiftBasicFormat',
            'SwiftOperators', 'SwiftIfConfig', '_SwiftSyntax', 'MacroToolboxSyntax', 'MacroToolboxTransflection',
            'ExpansionTimeTransflection', 'FixturePlugin', 'MacroToolboxMacrosPlugin')
def forbidden(name):
    return name in ('MacroToolbox', 'MacroToolbox-product') or name.startswith(prefixes)
for name in ['FixtureOptionsModels', 'FixtureMacros', 'FixtureExamples', 'FixtureClient']:
    ordinary, host = closure(name)
    assert not any(forbidden(n) for n in ordinary), ordinary
    assert {'MacroToolboxModels', 'ValueTransflection'}.issubset(ordinary), ordinary
    if name == 'FixtureOptionsModels': assert not host, host
    else: assert host == ['FixturePlugin'], host
    record[name + 'OrdinaryClosure'] = ordinary; record[name + 'HostTools'] = host
host, _ = closure('FixturePlugin', False)
assert {'SwiftSyntax', 'MacroToolbox', 'MacroToolboxTransflection', 'ExpansionTimeTransflection', 'FixtureOptionsModels'}.issubset(host), host
record['pluginHostClosure'] = host
paths = list(scratch.rglob('FixtureClient.LinkFileList'))
assert paths
for index, path in enumerate(paths):
    text = path.read_text()
    (out / f'runtime-link-inputs-{index}.txt').write_text(text)
    assert not any(name in text for name in prefixes), text
    assert '/MacroToolbox.o' not in text and '/MacroToolbox-t.build/' not in text, text
    assert all(name in text for name in ['FixtureOptionsModels', 'FixtureMacros', 'FixtureExamples', 'MacroToolboxModels', 'ValueTransflection']), text
for index, path in enumerate(scratch.rglob('FixturePlugin.LinkFileList')):
    shutil.copy2(path, out / f'host-link-inputs-{index}.txt')
dylibs = run(['otool', '-L', str(bin_path / 'FixtureClient')], 'runtime-dylibs')[0]
assert not any(name in dylibs for name in prefixes), dylibs

isolated = out / 'isolated-modules'; isolated.mkdir()
modules = ['FixtureOptionsModels', 'FixtureMacros', 'FixtureExamples', 'MacroToolboxModels', 'ValueTransflection']
for module in modules:
    shutil.copytree(bin_path / (module + '.swiftmodule'), isolated / (module + '.swiftmodule'))
isolated_compiler = [*compiler, '-module-cache-path', str(out / 'isolated-cache'), '-module-name', 'IsolatedFixtureClient', '-I', str(isolated),
                     str(fixture / 'Sources/FixtureClient/main.swift')]
run([*isolated_compiler, '-typecheck'], 'isolated-import')
scan = json.loads(run([*isolated_compiler, '-scan-dependencies'], 'isolated-dependencies')[0])
names = set()
def collect(value):
    if isinstance(value, dict):
        for key, child in value.items():
            if key in ('swift', 'swiftPrebuiltExternal', 'clang') and isinstance(child, str): names.add(child)
            collect(child)
    elif isinstance(value, list):
        for child in value: collect(child)
collect(scan)
assert set(modules) <= names and not any(forbidden(n) for n in names), names
record['compiledModuleDependencies'] = sorted(names)
record['completedAt'] = datetime.datetime.now(datetime.timezone.utc).isoformat()
save()
print('Public consumer passed: compiled behavior, expected diagnostics, host/runtime graph, links and isolated imports.')
