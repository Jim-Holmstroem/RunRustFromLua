# RunRustFromLua

Simple showcase on how to call Rust functions from Lua FFI.

It is currently supporting numeric, strings and structs.

## Run
Runs within a docker container so that the demonstration to be fairly platform independent.

```bash
make run
```

## Note
Many failures in Lua FFI produce the completely unrelated error message
```
luajit: bad argument #1 to '?' (cannot convert 'const char *' to 'char *')
```
check the functions are exported correctly (pub module, pub function, no_mangle etc).