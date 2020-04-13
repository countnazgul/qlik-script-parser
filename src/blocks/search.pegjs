// SEARCH

searchBlock
	= search:'SEARCH'i sep1:sep dir:('INCLUDE'i / 'EXCLUDE'i) sep2:sep fields:searchBlockFields
	{ return { dir: dir, fields: fields.fields, txt: () => computeText(arguments) }}
	
searchBlockFields
	= head:searchBlockField tail:(sep? ',' sep? searchBlockField)*
	{ return { fields: [ head ].concat(tail ? tail.map(e => e[3]) : []), txt: () => computeText(arguments) } }
	
searchBlockField
	= resource
	/ '*'

