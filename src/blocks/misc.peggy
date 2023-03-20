/*
 * Misc.
 */

blockEnd           = block:(sep? ';' sep?) { return block } // generic block end ;
blockEndSameLine   = block:(spaces? ';') { return block } // the ; should be on the same line. For example: rem comment;

// TODO - need validation
sep
	= chars:(sp1:spaces? nl:newline sp2:spaces? { return (sp1 ? sp1 : '') + nl + (sp2 ? sp2 : ''); } )+
		{ return chars.join(''); }
	/ chars:spaces
		{ return chars; }
 
tableName			= name:resource spaces? ':'																	{ return name;}

resources
	= head:resource tail:(sep? ',' sep? resource)*
	{
		return [head].concat(tail.map(res => res[3]));
	}

resource			= name:(
						lib:'lib://' res:[^ \t\r\n()]+		{ return { value: lib + res.join(''), 					txt: () => computeText(arguments) }; }
						/ name:('@'? alphanum)				{ return { value: (name[0] ? name[0] : '') + name[1], 	txt: () => computeText(arguments) }; }
						/ name:braceQuoteString				
						/ name:doubleQuoteString
						/ name:singleQuoteString
						/ name:diagonalQuoteString
					)
					{ return name;}
					
variableName		= name:alphanum
variableValue 		= expression