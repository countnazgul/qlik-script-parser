/*
 * Date & Time
 */
	
datetime			= date:date spaces time:time { return {date: date, time: time}; } 
date				= date:(digit digit digit digit '-' digit digit '-' digit digit) { return date.join(''); }
time				= time:(digit digit ':' digit digit ':' digit digit) { return time.join(''); }
	
/*
 * Spaces
 */

spacesNL			= spacesNL:(space / newline)+			{ return spacesNL.join(''); }
spaces				= spaces:space+							{ return spaces.join(''); }
sixSpaces			= spaces:(space space space space space space)
															{ return spaces.join(''); }

space				= chars:(' ' / '\t')					{ return chars; }

newline				= chars:('\r'? '\n') 					{ return chars.join(''); }

/*
 * Numbers
 */
number				= decimal / integer
decimal				= digits:('-'? digit+ '.' digit+ ) { return parseFloat((digits[0] ? digits[0] : '+') + digits[1].join("") + '.' + digits[3].join("")); }
integer				= digits:('-'? digit+) { return parseInt((digits[0] ? digits[0] : '+') + digits[1].join("")); }
digit				= [0-9]

/*
 * Strings
 */

anyString           = value:[a-zA-Z0-9.(): _-]+ { return value.join('') }
alphanum			= chars:[a-zA-Z0-9\xC0-\xFF_\.%\?#°º$§]+	{ return chars.join(''); }
endofrow			= chars:[^\r\n]*							{ return chars.join(''); }
spEndofrow			= spaces? ( newline / EOF )
EOF					= !.

strings
	= head:string tail:(sep? ',' sep? string)*
	{
		return tail.reduce(function(result, element) {
			return result.concat([element[3]])
		}, [ head ]);
    }
	
string				= doubleQuoteString / singleQuoteString / diagonalQuoteStrings


/*
 * Double quoted strings
 */

doubleQuoteStrings
	= head:doubleQuoteString tail:(sep? ',' sep doubleQuoteString)*
	{
		return tail.reduce(function(result, element) {
			return result.concat([element[3]])
		}, [ head ]);
    }
	
doubleQuoteString
	= opq:doubleQuote chars:doubleQuotechar* cq:doubleQuote
	{
		return { type: 'STR', value: chars.map(char => char.char).join(''), txt: () => computeText(arguments) };
	}

doubleQuotechar
 	= char:doubleQuoteUeChar
	{ return { char: char, txt: () => computeText(arguments) }}
	
	/ esc:doubleQuote sequence:(doubleQuote)
    { return { char: sequence, txt: () => computeText(arguments) }; }
	
    / sep:sep char:(doubleQuotechar / & doubleQuote)
    { return { char: sep + char, txt: () => computeText(arguments) }; }
    
doubleQuote			= "\""
doubleQuoteUeChar	= '\t' / [^\0-\x1F"]

/*
 * Single quoted strings
 */

singleQuoteStrings
	= head:singleQuoteString tail:(sep? ',' sep? singleQuoteString)*
	{
		return tail.reduce(function(result, element) {
			return result.concat([element[3]])
		}, [ head ]);
    }
	
singleQuoteString
	= oq:singleQuote chars:singleQuotechar* cq:singleQuote
	{
		return { type: 'STR', value: chars.map(char => char.char).join(''), txt: () => computeText(arguments) };
	}

singleQuotechar
 	= char:singleQuoteUeChar
	{ return { char: char, txt: () => computeText(arguments) }}
	
	/ esc:singleQuote sequence:(singleQuote)
    { return { char: sequence, txt: () => computeText(arguments) }; }
	
    / sep:sep char:(singleQuotechar / & singleQuote)
    { return { char: sep + char, txt: () => computeText(arguments) }; }
    
singleQuote			= "'"
singleQuoteUeChar	= '\t' / [^\0-\x1F']

/*
 * Diagonal quoted strings
 */

diagonalQuoteStrings
	= head:diagonalQuoteString tail:(sep? ',' sep? diagonalQuoteString)*
	{
		return tail.reduce(function(result, element) {
			return result.concat([element[3]])
		}, [ head ]);
    }
	
diagonalQuoteString
	= oq:diagonalQuote chars:diagonalQuotechar* cq:diagonalQuote
	{
		return { type: 'STR', value: chars.map(char => char.char).join(''), txt: () => computeText(arguments) };
	}

diagonalQuotechar
 	= char:diagonalQuoteUeChar
	{ return { char: char, txt: () => computeText(arguments) }}
	
	/ esc:diagonalQuote sequence:(diagonalQuote)
    { return { char: sequence, txt: () => computeText(arguments) }; }
	
    / sep:sep char:(diagonalQuotechar / & diagonalQuote)
    { return { char: sep + char, txt: () => computeText(arguments) }; }
    
diagonalQuote		= "`"
diagonalQuoteUeChar	= '\t' / [^\0-\x1F`]

/*
 * Braced quoted strings
 */
 
braceQuoteString
	= oq:openBrace chars:braceQuotechar* cq:closeBrace
	{
		return { type: 'STR', value: chars.map(char => char.char).join(''), txt: () => computeText(arguments) };
	}

braceQuotechar
 	= char:braceQuoteUeChar
	{ return { char: char, txt: () => computeText(arguments) }}
	
	/ esc:braceQuoteEscape sequence:(closeBrace)
    { return { char: sequence, txt: () => computeText(arguments) }; }
	
    / sep:sep char:(braceQuotechar / & closeBrace)
    { return { char: sep + char, txt: () => computeText(arguments) }; }

braceQuoteEscape	= '\\'
openBrace			= '['
closeBrace			= ']'
braceQuoteUeChar	= '\t' / [^\0-\x1F\]]