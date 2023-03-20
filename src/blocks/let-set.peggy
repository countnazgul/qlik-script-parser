// LET/SET block
letSetBlock = letset:('LET'i sep / 'SET'i sep)? sep1:sep? name:variableName sep3:sep* eq:'='  sep2:sep* value:letSetBlockValue sep* ';'
	{ return {
		type: letset ? letset[0] : 'LET',
		name: name,
		value: value.val,
		txt: () => computeText(arguments)
	}}
	
letSetBlockValue
	= & (sep? variableValue  sep? ';' spEndofrow ( EOF / block )) sep3:sep? val:variableValue	{ return { val: val, txt: () => computeText(arguments) } }
	/ val:spaces? & spEndofrow														{ return { val: val, txt: () => computeText(arguments) } }

// letSetBlockValue
// 	= & (sep? variableValue spEndofrow ( EOF / block )) sep3:sep? val:variableValue	{ return { val: val, txt: () => computeText(arguments) } }
// 	/ val:spaces? & spEndofrow	