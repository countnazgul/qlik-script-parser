// SOURCE

loadBlockSource
	= (
		  loadBlockSourceInline
		/ loadBlockSourceSQL
		/ loadBlockSourceResident
		/ loadBlockSourceAutogenerate
		/ loadBlockSourceFrom
	)

loadBlockSourceInline		=
	src:('INLINE'i )						sep1:sep
	ob:'['									sep2:sep?
		data: loadBlockSourceInlineRows
	cb:']'
	{
		return {
			loadBlockType: 'INLINE',

			data: {
				from: data.txt(),
				lib: false,
				table: false,
				params: false,
			
				fields: data.fields,
				rows: data.rows
			},
			
			txt: () => computeText(arguments)
		}
	}

loadBlockSourceInlineRows 	=
	header:	(loadBlockSourceInlineHeader)
	rows:	(sep	loadBlockSourceInlineRow)*
	{
		return {
			fields: header.split(',').map(field => field.trim()),
			rows: rows.map(row => row[1]),
			txt: () => computeText(arguments)
		}
	}
	
loadBlockSourceInlineHeader	= endofinlinerow
loadBlockSourceInlineRow	= endofinlinerow

endofinlinerow				= chars:[^\]\r\n]*						{ return chars.join(""); }

loadBlockSourceSQL			=
	s:('SQL'i & ( sep 'SELECT'i ) / & 'SELECT'i )  values:(endofrow sep)* value:endofrow
	{
		return {
			loadBlockType: 'SQL',

			data: {
				from: values.map(row => row.join('')).join('') + value,
				lib: false,
				table: false,
				params: false,
			},
			txt: () => computeText(arguments)
		}
	}
	
loadBlockSourceResident		=
	r:('RESIDENT'i ) sep1:sep source:resource
	{
		return {
			loadBlockType: 'RESIDENT',

			data: {
				from: source.value,
				lib: false,
				table: source.value,
				params: false
			},
			
			txt: () => computeText(arguments)
		}
	}
	
loadBlockSourceAutogenerate		=
	a:('AUTOGENERATE'i ) sep:( sep / & '(' ) expr:expression
	{
		return {
			loadBlockType: 'AUTOGENERATE',

			data: {
				from: computeText(arguments),
				lib: false,
				table: false,
				params: false,
			
				value: expr
			},
			txt: () => computeText(arguments)
		}
	}
	
loadBlockSourceFrom		=
	f:('FROM'i ) sep1:sep src:resource params:(sep? '(' loadBlockSourceFromParams ')')?
	{
		return {
			loadBlockType: 'FROM',

			data: {
				from: src.value,
				lib: false,
				table: false,
				params: params ? params[2].params : false
			},
			
			txt: () => computeText(arguments)
		}
	}
	
loadBlockSourceFromParams
	= head:loadBlockSourceFromParam tail:(sep? ',' sep loadBlockSourceFromParam)*
	{
		return {
			params:tail.reduce(function(result, element) {
				return result.concat([element[3]])
			}, [ head ]),
			txt: () => computeText(arguments)
		}
		
    }
	
loadBlockSourceFromParam
	= d:'delimiter'i sp1:spaces i:'is'i sp2:spaces delim:resource				{ return { delimiter: true, value: delim.value,	txt: () => computeText(arguments) }; }
	/ t:'table'i sp1:spaces 'is'i sp2:spaces table:resource						{ return { table: true, value: table.value,		txt: () => computeText(arguments) }; }
	/ chars:[^,\)]*																{ return chars.join(''); }

	
