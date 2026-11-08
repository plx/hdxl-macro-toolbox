#!/usr/bin/env python3
"""Compile and execute actual public-API-generated Swift, retaining positive/negative evidence."""
import argparse, datetime, json, pathlib, platform, re, shutil, subprocess, sys

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--output', type=pathlib.Path, required=True)
args = parser.parse_args()
fixture = pathlib.Path(__file__).resolve().parent
out = args.output.resolve()
out.mkdir(parents=True, exist_ok=False)
record = {'commands': [], 'startedAt': datetime.datetime.now(datetime.timezone.utc).isoformat()}
def run(argv, label, fail=False, cwd=fixture):
    print(label, flush=True)
    p = subprocess.run(argv, cwd=cwd, capture_output=True, text=True)
    (out / (label + '.log')).write_text(p.stdout)
    (out / (label + '.stderr')).write_text(p.stderr)
    record['commands'].append({'argv': argv, 'exitCode': p.returncode, 'label': label, 'expectedFailure': fail})
    (out / 'validation.json').write_text(json.dumps(record, indent=2) + '\n')
    assert (p.returncode != 0) == fail, f'{label}: see {out}'
    return p.stdout, p.stderr

assert sys.platform == 'darwin'
assert re.search(r'Swift version 6\.4(?:\.|\s)', run(['swift', '--version'], 'swift-version')[0])
run(['sw_vers'], 'macos-version')
run(['xcodebuild', '-version'], 'xcode-version')
run(['xcodebuild', '-showsdks'], 'sdks')
run(['git', 'rev-parse', 'HEAD'], 'source-revision', cwd=fixture.parent.parent)
run(['git', 'status', '--short'], 'source-status', cwd=fixture.parent.parent)
options = ['--package-path', str(fixture), '--scratch-path', str(out / 'build')]
run(['swift', 'package', *options, 'resolve'], 'resolve')
run(['swift', 'package', *options, 'dump-package'], 'manifest')
run(['swift', 'package', *options, 'show-dependencies', '--format', 'json'], 'dependencies')
shutil.copy2(fixture / 'Package.resolved', out / 'Package.resolved')
run(['swift', 'build', *options, '--product', 'Generate'], 'build-generator')
binary = pathlib.Path(run(['swift', 'build', *options, '--show-bin-path'], 'bin-path')[0].strip())
source, _ = run([str(binary / 'Generate')], 'generate')
(out / 'Generated.swift').write_text(source)
sdk = run(['xcrun', '--sdk', 'macosx', '--show-sdk-path'], 'sdk-path')[0].strip()
compiler = ['swiftc', '-swift-version', '6', '-sdk', sdk, '-target', platform.machine() + '-apple-macosx27.0', '-module-cache-path', str(out / 'compiler-cache')]
run([*compiler, str(out / 'Generated.swift'), '-o', str(out / 'Generated')], 'compile-generated')
assert 'Generated construction fixture passed' in run([str(out / 'Generated')], 'run-generated')[0]
negative, _ = run([str(binary / 'Generate'), '--insufficient-witness'], 'generate-insufficient-witness')
assert 'internal var description' in negative and 'public var description' not in negative
(out / 'InsufficientWitness.swift').write_text(negative)
_, stderr = run([*compiler, '-typecheck', str(out / 'InsufficientWitness.swift')], 'reject-insufficient-witness', fail=True)
assert 'must be declared public' in stderr and 'description' in stderr
shim = out / 'build/checkouts/swift-syntax/Sources/_SwiftSyntaxCShims/include'
module_options = ['-I', str(binary), '-I', str(shim)]
run([*compiler, '-typecheck', *module_options, str(fixture / 'TypedInputMustPass.swift')], 'accept-typed-input')
_, stderr = run([*compiler, '-typecheck', *module_options, str(fixture / 'RawStringMustFail.swift')], 'reject-raw-string', fail=True)
assert "cannot convert value of type 'String'" in stderr and 'TypeSyntax' in stderr
record['completedAt'] = datetime.datetime.now(datetime.timezone.utc).isoformat()
(out / 'validation.json').write_text(json.dumps(record, indent=2) + '\n')
print('Passed generated Swift compilation/execution and both compiler rejection checks.')
