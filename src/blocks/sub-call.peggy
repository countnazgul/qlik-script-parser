// SUB & CALL

subBlock
	= sub:'SUB'i sep1:sep name:resource params:( sep? '(' params:resources ')' { return params; } )?
	{ return { name: name, params: params, txt: () => computeText(arguments) }; }
	
callBlock
	= cal:'CALL'i sep1:sep name:resource params:( sep? '(' params:expressions ')' { return params; } )?
	{ return { name: name, params: params, txt: () => computeText(arguments) }; }


