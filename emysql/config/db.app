{
	application, db,
	[
		{description, "Emysql test"},
		{vsn, "0.1.0"},
		{modules, [db_app]},
		{registered, [db_app]},
		{applications, [kernel, stdlib]},
		{mod, {db_app, []}}
	]
}.