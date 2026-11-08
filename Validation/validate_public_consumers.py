#!/usr/bin/env python3
"""One Swift 6.4 / Apple 27 gate for toolbox and its independently built public consumers."""
import argparse, datetime, json, pathlib, re, shutil, subprocess, sys
parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--output', type=pathlib.Path, required=True, help='new evidence/build directory')
args = parser.parse_args()
root = pathlib.Path(__file__).resolve().parent.parent
out = args.output.resolve(); out.mkdir(parents=True, exist_ok=False)
record = {'commands': [], 'startedAt': datetime.datetime.now(datetime.timezone.utc).isoformat()}
def save(): (out / 'validation.json').write_text(json.dumps(record, indent=2) + '\n')
def run(argv, label):
    print(label, flush=True)
    with (out / (label + '.log')).open('w') as stdout, (out / (label + '.stderr')).open('w') as stderr:
        result = subprocess.run(argv, cwd=root, stdout=stdout, stderr=stderr)
    record['commands'].append(dict(argv=argv, exitCode=result.returncode, label=label)); save()
    if result.returncode: sys.exit(f'{label} failed; see {out}. No gate is skipped.')
    return (out / (label + '.log')).read_text()
if sys.platform != 'darwin': sys.exit('Required environment unavailable: macOS with Swift 6.4 and Apple 27 SDKs.')
if not re.search(r'Swift version 6\.4(?:\.|\s)', run(['swift', '--version'], 'swift-version')):
    sys.exit('Required Swift 6.4 toolchain unavailable.')
run(['sw_vers'], 'macos-version'); run(['xcodebuild', '-version'], 'xcode-version'); run(['xcodebuild', '-showsdks'], 'sdks')
if run(['xcrun', '--sdk', 'macosx', '--show-sdk-version'], 'macos-sdk-version').strip().split('.')[0] != '27':
    sys.exit('Required macOS 27 SDK unavailable.')
run(['git', 'rev-parse', 'HEAD'], 'source-revision'); run(['git', 'status', '--short'], 'source-status')
options = ['--package-path', str(root), '--scratch-path', str(out / 'root-build')]
for label, command in [
    ('resolve', ['swift', 'package', *options, 'resolve']),
    ('manifest', ['swift', 'package', *options, 'dump-package']),
    ('dependencies', ['swift', 'package', *options, 'show-dependencies', '--format', 'json']),
    ('build', ['swift', 'build', *options, '-v']),
    ('test', ['swift', 'test', *options])
]:
    run(command, label)
shutil.copy2(root / 'Package.resolved', out / 'Package.resolved')
record['resolved'] = json.loads((root / 'Package.resolved').read_text())
syntax_pin = next(p for p in record['resolved']['pins'] if p['identity'] == 'swift-syntax')
assert syntax_pin['state']['version'].split('.')[0] == '604', syntax_pin
core = out / 'root-build/checkouts/hdxl-macro-transflection'
assert core.is_dir(), 'Resolved core checkout is required for reverse-edge validation.'
run(['swift', 'package', '--package-path', str(core), 'dump-package'], 'core-manifest')
run(['python3', str(root / 'Validation/check_target_graph.py'), '--self-test',
     '--core-manifest', str(out / 'core-manifest.log'), '--output', str(out / 'target-guard.json')], 'target-guard')
for fixture in ['TargetBoundaries', 'TypedConstructionConsumer', 'PublicMacroConsumer']:
    run(['python3', str(root / 'IntegrationFixtures' / fixture / 'validate.py'),
         '--output', str(out / fixture)], 'fixture-' + fixture)
    result = json.loads((out / fixture / 'validation.json').read_text())
    assert result.get('completedAt'), fixture
record['completedAt'] = datetime.datetime.now(datetime.timezone.utc).isoformat(); save()
print('All toolbox public-consumer gates passed.')
