// IF block

ifBlock				=
	e:('ELSE'i spaces?)? i:'IF'i sp1:spaces condition:expression sp2:spaces t:'THEN'i
	{ return { condition: condition, txt: () => computeText(arguments) } } 

