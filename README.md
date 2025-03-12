initial work on openxr support for vision os targetting godot

openxrconfig.json e.g.
```
{
    "file_format_version": "1.0.0",
    "runtime": {
        "name": "OpenXRRuntime",
        "library_path": "@executable_path/Frameworks/OpenXRRuntime.framework/OpenXRRuntime"
    }
}
```

env var for game project
`XR_RUNTIME_JSON=@executable_path/../Resources/openxr_runtime.json`
