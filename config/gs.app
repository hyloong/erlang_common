{
    application, gs,
    [
        {description, "game server"},
        {vsn, "1.0"},
        {modules, [gs1]},
        {registered, [gs_app]},
        {applications, [kernel, stdlib, sasl]},
        {mod, {gs_app, []}}
    ]
}.
