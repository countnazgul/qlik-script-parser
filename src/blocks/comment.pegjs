// COMMENT

commentBlock
	= commentBlock: scriptCommentBlock endofrow

													{ return { val: val, txt: () => computeText(arguments) } }

// COMMENT block
 
scriptCommentBlock  = 
	multiLine:multiLineCommentBlock { return { comment: multiLine, txt: () => computeText(arguments) }}
	/ singleLineComment:singleLineCommentBlock { return { comment: singleLineComment, txt: () => computeText(arguments) }}
	/ remLineComment:remCommentBlock { return { comment: remLineComment, txt: () => computeText(arguments) }}

singleLineCommentBlock = sep? '//' p:([^\n]*) { return { type: 'SINGLE LINE', comment: p.join(''), txt: () => computeText(arguments) }}
multiLineCommentBlock  = "/*" inner:(!"*/" i:. {return i})* "*/" { return { type: 'MULTI LINE', comment: inner.join(''), txt: () => computeText(arguments) }}
remCommentBlock        = spaces? 'REM'i a:anyString* blockEndSameLine { return { type: 'REM', comment: a.join(''), txt: () => computeText(arguments) }}

