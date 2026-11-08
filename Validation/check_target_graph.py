#!/usr/bin/env python3
"""Check `swift package dump-package` output; --self-test mutates each forbidden edge."""
import argparse, copy, json, re, subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ALLOWED = {
    'MacroToolboxModels': {'ValueTransflection'},
    'MacroToolboxSyntax': {'MacroToolboxModels', 'SwiftSyntax', 'SwiftParser', 'SwiftSyntaxBuilder', 'SwiftBasicFormat'},
    'MacroToolbox': {'MacroToolboxModels', 'MacroToolboxSyntax', 'SwiftSyntax', 'SwiftParser', 'SwiftSyntaxBuilder', 'SwiftSyntaxMacros', 'SwiftDiagnostics'},
    'MacroToolboxTransflection': {'MacroToolboxModels', 'MacroToolboxSyntax', 'MacroToolbox', 'ValueTransflection', 'ExpansionTimeTransflection', 'SwiftSyntax', 'SwiftSyntaxMacros', 'SwiftDiagnostics'},
    'BridgeTestModels': {'MacroToolboxModels', 'ValueTransflection'},
    'TransflectionBridgeTests': {'BridgeTestModels', 'MacroToolboxModels', 'MacroToolboxSyntax', 'MacroToolbox', 'MacroToolboxTransflection', 'ValueTransflection', 'ExpansionTimeTransflection', 'SwiftSyntax', 'SwiftParser', 'SwiftSyntaxBuilder', 'SwiftSyntaxMacros', 'SwiftDiagnostics', 'SwiftSyntaxMacroExpansion'},
    'MacroToolboxMacros': {'MacroToolboxMacrosPlugin', 'MacroToolboxModels'},
    'MacroToolboxMacrosPlugin': {'MacroToolbox', 'MacroToolboxModels', 'MacroToolboxSyntax', 'SwiftSyntax', 'SwiftParser', 'SwiftSyntaxBuilder', 'SwiftSyntaxMacros', 'SwiftCompilerPlugin', 'SwiftDiagnostics'},
    'MacroToolboxMacrosClient': {'MacroToolboxMacros', 'MacroToolboxModels'},
    'MacroToolboxTestSupport': set(),
    'MacroToolboxTests': {'MacroToolbox', 'MacroToolboxModels', 'MacroToolboxSyntax', 'MacroToolboxTestSupport'},
    'FieldAnalysisPublicTests': {'MacroToolboxModels', 'MacroToolboxSyntax', 'SwiftSyntax', 'SwiftParser'},
}

def dependency_name(dependency):
    for kind in ['byName', 'target', 'product']:
        if kind in dependency:
            return dependency[kind][0]
    raise AssertionError(f'Unrecognized dependency: {dependency}')

def check(manifest, core=None):
    errors = []
    targets = {t['name']: t for t in manifest['targets']}
    for required in ALLOWED:
        if required not in targets: errors.append(f'Missing target {required}')
    for name, target in targets.items():
        if name not in ALLOWED:
            errors.append(f'Uninventoried target {name}'); continue
        for dependency in target.get('dependencies', []):
            dep = dependency_name(dependency)
            if dep not in ALLOWED[name]: errors.append(f'Forbidden edge {name} -> {dep}')
    # Test-only edges and renamed aliases must not smuggle in the downstream generator package.
    if 'hdxl-macro-transflection-macros' in json.dumps(manifest.get('dependencies', [])).lower():
        errors.append('Toolbox must not depend on the downstream derivation package')
    if targets.get('MacroToolboxMacrosPlugin', {}).get('type') != 'macro':
        errors.append('The declaration wrapper dependency must be a compiler-host macro target')
    if core is not None:
        if 'toolbox' in json.dumps(core.get('dependencies', [])).lower():
            errors.append('Core must not depend back on toolbox')
        for target in core['targets']:
            for dep in target.get('dependencies', []):
                if 'toolbox' in dependency_name(dep).lower():
                    errors.append(f'Core reverse edge {target["name"]} -> {dependency_name(dep)}')
    return errors

def check_sources():
    errors = []
    for folder, allowed in [('MacroToolboxModels', {'ValueTransflection'}), ('MacroToolboxSyntax', {'MacroToolboxModels','SwiftSyntax','SwiftParser','SwiftSyntaxBuilder','SwiftBasicFormat'}), ('MacroToolboxMacros', {'MacroToolboxModels'})]:
        for path in (ROOT/'Sources'/folder).rglob('*.swift'):
            for module in re.findall(r'^\s*(?:(?:public|internal|package|private)\s+)?import\s+(\w+)',path.read_text(),re.M):
                if module not in allowed: errors.append(f'Forbidden import {path.relative_to(ROOT)} -> {module}')
    for path in (ROOT/'Tests'/'BridgeTestModels').rglob('*.swift'):
        for module in re.findall(r'^\s*import\s+(\w+)', path.read_text(), re.M):
            if module not in {'MacroToolboxModels', 'ValueTransflection'}:
                errors.append(f'Forbidden pure fixture import {path.relative_to(ROOT)} -> {module}')
    return errors

def self_test(manifest, core):
    cases = []
    for source, destinations in {
        'MacroToolboxModels': ['MacroToolboxTransflection','SwiftSyntax','SwiftDiagnostics','SwiftSyntaxMacros','MacroToolboxSyntax','MacroToolbox','MacroToolboxMacros','ExpansionTimeTransflection','MacroTransflectionMacros'],
        'MacroToolboxSyntax': ['MacroToolboxTransflection','ExpansionTimeTransflection','MacroToolbox','MacroToolboxMacros','SwiftSyntaxMacros','SwiftCompilerPlugin','SwiftDiagnostics','MacroTransflectionMacros'],
        'MacroToolboxMacros': ['MacroToolboxTransflection','MacroToolbox','MacroToolboxSyntax','SwiftSyntax','SwiftDiagnostics','SwiftSyntaxMacros','ExpansionTimeTransflection'],
        'MacroToolboxMacrosClient': ['MacroToolboxTransflection','MacroToolbox','MacroToolboxSyntax','SwiftSyntax'],
        'MacroToolbox': ['MacroToolboxTransflection','MacroTransflectionMacros'],
        'MacroToolboxTransflection': ['MacroTransflectionMacros', 'MacroToolboxMacros'],
        'BridgeTestModels': ['SwiftSyntax', 'SwiftDiagnostics', 'ExpansionTimeTransflection', 'MacroToolboxTransflection', 'MacroToolbox'],
        'TransflectionBridgeTests': ['MacroTransflectionMacros'],
        'MacroToolboxTests': ['MacroTransflectionMacros'],
        'FieldAnalysisPublicTests': ['MacroToolbox', 'MacroToolboxMacros', 'SwiftSyntaxMacros', 'MacroTransflectionMacros'],
    }.items():
        for destination in destinations:
            mutated=copy.deepcopy(manifest)
            next(t for t in mutated['targets'] if t['name']==source)['dependencies'].append({'byName':[destination,None]})
            assert check(mutated,core),f'Guard missed {source} -> {destination}'
            cases.append(f'{source} -> {destination}')
    mutated=copy.deepcopy(manifest);mutated['dependencies'].append({'url':'https://github.com/plx/hdxl-macro-transflection-macros'})
    assert check(mutated,core);cases.append('Toolbox package -> derivation package')
    mutated=copy.deepcopy(manifest);next(t for t in mutated['targets'] if t['name']=='MacroToolboxMacrosPlugin')['type']='regular'
    assert check(mutated,core);cases.append('Plugin changed to ordinary target')
    for source in ['ValueTransflection','ExpansionTimeTransflection']:
        mutated=copy.deepcopy(core)
        next(t for t in mutated['targets'] if t['name']==source)['dependencies'].append({'byName':['MacroToolbox',None]})
        assert check(manifest,mutated);cases.append(f'{source} -> MacroToolbox')
    mutated=copy.deepcopy(core);mutated['dependencies'].append({'url':'https://github.com/plx/hdxl-macro-toolbox'})
    assert check(manifest,mutated);cases.append('Core package -> toolbox package')
    return cases

def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--manifest',type=Path)
    parser.add_argument('--core-manifest',type=Path)
    parser.add_argument('--self-test',action='store_true')
    parser.add_argument('--output',type=Path)
    args=parser.parse_args()
    manifest=json.loads(args.manifest.read_text()) if args.manifest else json.loads(subprocess.check_output(['swift','package','dump-package'],cwd=ROOT))
    core=json.loads(args.core_manifest.read_text()) if args.core_manifest else {'targets':[{'name':'ValueTransflection','dependencies':[]},{'name':'ExpansionTimeTransflection','dependencies':[{'byName':['ValueTransflection',None]}]}],'dependencies':[]}
    errors=check(manifest,core)+check_sources()
    report={'status':'failed' if errors else 'passed','errors':errors,'core_manifest_checked':str(args.core_manifest) if args.core_manifest else None,'targets':{t['name']:[dependency_name(d) for d in t['dependencies']] for t in manifest['targets']}}
    if args.self_test:report['mutation_checks']=self_test(manifest,core)
    if args.output:args.output.write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps(report,indent=2))
    if errors:raise SystemExit(1)

if __name__=='__main__':main()
