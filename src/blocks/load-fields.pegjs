// LOAD
	
loadBlockLoad		=
	load:		('LOAD'i			sep)
	distinct:	('DISTINCT'i		sep)?
	fields:		(loadBlockFields	)
	{
		return {
			distinct: distinct ? true : false,
			fields: fields.fields,
			txt: () => computeText(arguments)
		};
	}
	
loadBlockFields
	= head:loadBlockField tail:(sep? ',' sep? loadBlockField)*
	{
		return {
			fields: tail.reduce(function(result, element) {
				return result.concat([element[3]])
			}, [ head ]),
			txt: () => computeText(arguments)
		};
		
    }
	
loadBlockField
	= '*'
	/ expr:expression as:(sep? 'AS'i sep? resource)? {
		return {
			expr: expr,
			field: (as && as[3]) ? as[3].value : expr.value,
			txt: () => computeText(arguments)
		}
	}


