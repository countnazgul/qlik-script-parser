// LET/SET block
letSetBlock = letSet:('LET'i sep / 'SET'i sep)? sep1:sep? name:variableName sep3:sep* eq:'='  sep2:sep* value:letSetBlockValue sep* ';'
	{ return {
		type: letSet ? letSet[0] : 'LET',
		name: name,
		value: value.val,
		txt: () => computeText(arguments)
	}}
	
letSetBlockValue
	= & (sep? variableValue  sep? ';' spEndOfRow ( EOF / block )) sep3:sep? val:variableValue	{ return { val: val, txt: () => computeText(arguments) } }
	/ val:spaces? & spEndOfRow														{ return { val: val, txt: () => computeText(arguments) } }

// letSetBlockValue
// 	= & (sep? variableValue spEndOfRow ( EOF / block )) sep3:sep? val:variableValue	{ return { val: val, txt: () => computeText(arguments) } }
// 	/ val:spaces? & spEndOfRow	