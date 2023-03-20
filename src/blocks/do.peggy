// DO block

doBlock
	= 'DO'i w:doBlockWhile?
	{ return { while: w ? w.expr : false, txt: () => computeText(arguments) }}
	
doBlockWhile
	= s1:sep w:'WHILE'i s2:sep expr:expression
	{ return { expr: expr, txt: () => computeText(arguments) }}