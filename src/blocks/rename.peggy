// RENAME block

renameBlock
	= r:'RENAME'i s1:sep f:('FIELD'i / 'TABLE'i) s:('S'i)? s2:sep u:'USING'i s3:sep using:resource
	{
		return {
			using: using,
			txt: () => computeText(arguments)
		}
	}
	/ 'RENAME'i sep ('FIELD'i / 'TABLE'i) ('S'i)? sep fromTo:renameBlockFromTo fromTos:renameBlockFromToSepComma*
	{
		return {
			fromTos: [fromTo].concat(fromTos ? fromTos.map(fromTo => fromTo.fromTo) : []),
			txt: () => computeText(arguments)
		}
	}
  
renameBlockFromToSepComma
	= s1:sep? c:',' s2:sep? fromTo:renameBlockFromTo
	{ return { fromTo: fromTo, txt: () => computeText(arguments) }}
  
renameBlockFromTo
	= from:resource s1:sep t:'TO'i s2:sep to:resource
	{ return { from: from, to: to, txt: () => computeText(arguments) }}

