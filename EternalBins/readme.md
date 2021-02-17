# Eternal Bins

This is a collection of the native binaries bundled with our latest releases. They are made using mkbundle, with the compiled executables for Mono.

## Compiling

To compile this binaries yourself, first compile the source code from any of the tools into a Windows-type executable.
Then, copy and edit Mono's config file as explained in this [issue](https://github.com/mono/mono/issues/16991#issuecomment-534147981).
Afterwards, use the following commands to compile:

DEternal_loadMods:
```
mkbundle --simple --static --deps -o DEternal_loadMods DEternal_loadMods.exe --machine-config /usr/etc/mono/4.5/machine.config --config ./config --library /usr/lib/libmono-native.so --library /usr/lib/libMonoPosixHelper.so
```

EternalPatcher:
```
mkbundle --simple --static --deps -o EternalPatcher EternalPatcher.exe --machine-config /usr/etc/mono/4.5/machine.config --config ./config --library /usr/lib/libmono-native.so --library /usr/lib/libmono-btls-shared.so
```
