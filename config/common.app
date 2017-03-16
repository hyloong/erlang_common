{
    application, common,
    [
        {description, "a common app"},
        {vsn, "1.0"},
        {modules, [common]},
        {registered, [common_app]},
        {applications, [kernel, stdlib]},
        {mod, {common_app, []}}
    ]
}.