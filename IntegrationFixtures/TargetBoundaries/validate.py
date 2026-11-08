#!/usr/bin/env python3
"""Build focused external consumers and inspect actual ordinary/host compiler and linker boundaries."""
import argparse, datetime, json, pathlib, platform, re, shutil, subprocess, sys

parser=argparse.ArgumentParser(description=__doc__)
parser.add_argument('--output',type=pathlib.Path,required=True)
args=parser.parse_args()
fixture=pathlib.Path(__file__).resolve().parent
root=fixture.parent.parent
out=args.output.resolve();out.mkdir(parents=True,exist_ok=False)
scratch=out/'build'
record={'commands':[],'startedAt':datetime.datetime.now(datetime.timezone.utc).isoformat()}
def save(): (out/'validation.json').write_text(json.dumps(record,indent=2)+'\n')
def run(argv,label,cwd=fixture):
    print(label,flush=True)
    with (out/(label+'.log')).open('w') as stdout,(out/(label+'.stderr')).open('w') as stderr:
        p=subprocess.run(argv,cwd=cwd,stdout=stdout,stderr=stderr)
    record['commands'].append({'argv':argv,'exitCode':p.returncode,'label':label});save()
    if p.returncode:sys.exit(f'{label} failed; see {out}')
    return (out/(label+'.log')).read_text()
assert sys.platform=='darwin','macOS host required'
assert re.search(r'Swift version 6\.4(?:\.|\s)',run(['swift','--version'],'swift-version'))
run(['sw_vers'],'macos-version');run(['xcodebuild','-version'],'xcode-version');run(['xcodebuild','-showsdks'],'sdks')
run(['git','rev-parse','HEAD'],'source-revision',root);run(['git','status','--short'],'source-status',root)
run(['python3',str(root/'Validation/check_target_graph.py'),'--self-test','--output',str(out/'target-guard.json')],'target-guard',root)
options=['--package-path',str(fixture),'--scratch-path',str(scratch)]
run(['swift','package',*options,'resolve'],'resolve')
run(['swift','package',*options,'dump-package'],'fixture-manifest')
run(['swift','package',*options,'show-dependencies','--format','json'],'dependencies')
run(['swift','build',*options,'--product','ModelsOnly','-v'],'models-build')
run(['swift','run',*options,'--skip-build','ModelsOnly'],'models-run')
bin_path=pathlib.Path(run(['swift','build',*options,'--show-bin-path'],'bin-path').strip())
model_objects=sorted(str(p.relative_to(scratch)) for p in scratch.rglob('*.o'))
assert model_objects and not any('SwiftSyntax' in p or 'MacroToolboxSyntax' in p or 'MacroToolboxMacros' in p or 'ExpansionTimeTransflection' in p or 'SwiftDiagnostics' in p or 'MacroToolboxTransflection' in p for p in model_objects),model_objects
record['modelOnlyBuiltObjects']=model_objects;save()
shutil.copy2(scratch/'manifest.pif',out/'models-build-graph.pif')
# Prove the public model module can be imported from a separate compiler/cache with no syntax modules.
isolated=out/'isolated-model';isolated.mkdir()
for module in ['MacroToolboxModels', 'ValueTransflection']:
    shutil.copytree(bin_path/(module+'.swiftmodule'),isolated/(module+'.swiftmodule'))
sdk=run(['xcrun','--sdk','macosx','--show-sdk-path'],'sdk-path').strip()
compiler=['swiftc','-swift-version','6','-module-name','IsolatedModelsOnly','-I',str(isolated),'-module-cache-path',str(out/'isolated-cache'),'-sdk',sdk,'-target',platform.machine()+'-apple-macosx27.0',str(fixture/'Sources/ModelsOnly/main.swift')]
run(compiler+['-typecheck'],'isolated-model-typecheck')
scan=run(compiler+['-scan-dependencies'],'isolated-model-dependencies')
assert all(module not in scan for module in ['SwiftSyntax', 'SwiftDiagnostics', 'MacroToolboxSyntax', 'ExpansionTimeTransflection', 'MacroToolboxTransflection'])
assert 'ValueTransflection' in scan
run(['swift','build',*options,'--product','SyntaxOnly','-v'],'syntax-build')
run(['swift','run',*options,'--skip-build','SyntaxOnly'],'syntax-run')
run(['swift','build',*options,'--product','BridgeOnly','-v'],'bridge-build')
run(['swift','run',*options,'--skip-build','BridgeOnly'],'bridge-run')
run(['swift','build',*options,'--product','GatheringClient','-v'],'macros-build')
run(['swift','run',*options,'--skip-build','GatheringClient'],'macros-run')
pif=json.loads((scratch/'manifest.pif').read_text());shutil.copy2(scratch/'manifest.pif',out/'complete-build-graph.pif')
targets={i['contents']['guid']:i['contents'] for i in pif if i['type']=='target'}
def closure(name,skip_host=True):
    seen,host=set(),set()
    def visit(guid):
        t=targets[guid]
        if skip_host and t.get('productTypeIdentifier')=='com.apple.product-type.tool.host-build':host.add(t['name']);return
        if guid in seen:return
        seen.add(guid)
        for d in t.get('dependencies',[]):visit(d['guid'])
    visit('PACKAGE-TARGET:'+name)
    return sorted({targets[g]['name'] for g in seen}),sorted(host)
for name,expected in [('MacroToolboxModels',{'MacroToolboxModels','ValueTransflection','ValueTransflection-product'}),('MacroToolboxMacros',{'MacroToolboxMacros'})]:
    names,host=closure(name);assert set(names)==expected,(name,names)
    record[name+'OrdinaryClosure']=names;record[name+'HostTools']=host
syntax,host=closure('MacroToolboxSyntax')
assert not host and all(n not in syntax for n in ['MacroToolbox','SwiftSyntaxMacros','SwiftCompilerPlugin']),syntax
assert 'MacroToolboxModels' in syntax and 'SwiftSyntax' in syntax and 'SwiftDiagnostics' in syntax,syntax
record['syntaxClosure']=syntax
assert 'MacroToolboxTransflection' not in syntax and 'ExpansionTimeTransflection' not in syntax,syntax
bridge,bridge_host=closure('MacroToolboxTransflection')
assert not bridge_host and {'MacroToolbox', 'ValueTransflection', 'ExpansionTimeTransflection', 'SwiftSyntax', 'SwiftDiagnostics'}.issubset(bridge),bridge
assert not any('MacroTransflectionMacros' in n or 'BridgeTestModels' in n for n in bridge),bridge
record['bridgeHostLibraryClosure']=bridge
record['syntaxDiagnosticReason']='Existing public validated()/eraseToValidated* and string construction use SwiftSyntaxBuilder parser diagnostics; no macro context framework is included.'
host,_=closure('MacroToolboxMacrosPlugin',False)
assert all(n in host for n in ['MacroToolbox','MacroToolboxSyntax','MacroToolboxModels','SwiftSyntax']),host
record['pluginHostClosure']=host
for name,allowed in [('ModelsOnly',{'ModelsOnly','MacroToolboxModels','ValueTransflection'}),('GatheringClient',{'GatheringClient','MacroToolboxMacros'})]:
    paths=list(scratch.rglob(name+'.LinkFileList'));assert paths,name
    for i,p in enumerate(paths):
        text=p.read_text();(out/f'{name}-link-inputs-{i}.txt').write_text(text)
        assert not any(bad in text for bad in ['SwiftSyntax','SwiftParser','SwiftDiagnostics','MacroToolboxSyntax','MacroToolbox-t','MacroToolboxMacrosPlugin','MacroToolboxTransflection','ExpansionTimeTransflection']),text
        assert all(module in text for module in allowed),text
    linked=run(['otool','-L',str(bin_path/name)],name+'-dylibs')
    assert not any(bad in linked for bad in ['SwiftSyntax','SwiftParser','SwiftDiagnostics','MacroToolboxSyntax','MacroToolboxMacrosPlugin','MacroToolboxTransflection','ExpansionTimeTransflection']),linked
for i,p in enumerate(scratch.rglob('MacroToolboxMacrosPlugin.LinkFileList')):shutil.copy2(p,out/f'plugin-link-inputs-{i}.txt')
record['completedAt']=datetime.datetime.now(datetime.timezone.utc).isoformat();save()
print('Passed model-only compilation, public imports, explicit host bridge, all four macros, graph mutation checks, ordinary/host closure and runtime link checks.')
