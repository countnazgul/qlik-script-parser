// SUFFIXES
	
loadBlockSuffixes
	= head:loadBlockSuffix tail:(sep loadBlockSuffix)*
	{
		return {
			suffixes:tail.reduce(function(result, element) {
				Object.keys(element[1]).forEach(key => result[key] = element[1][key])
				return result;
			}, head),
			txt: () => computeText(arguments)
		};
    }
	
loadBlockSuffix
	= suffix:'WHILE'i s1:sep exprWhile:expression										{ return { while: exprWhile, 				txt: () => computeText(arguments) }}
	/ suffix:'WHERE'i s1:sep exprWhere:expression										{ return { where: exprWhere, 				txt: () => computeText(arguments) }}
	/ suffix:'GROUP'i s1:spaces b:'BY'i s2:sep groupbyFields:loadBlockGroupByFields		{ return { groupby: groupbyFields.fields, 	txt: () => computeText(arguments) }}
	/ suffix:'ORDER'i s1:spaces b:'BY'i s2:sep orderbyFields:loadBlockOrderByFields		{ return { orderby: orderbyFields.fields, 	txt: () => computeText(arguments) }}

loadBlockGroupByFields
	= head:loadBlockGroupByField tail:(sep? ',' sep? loadBlockGroupByField)*
	{
		return {
			fields: tail.reduce(function(result, element) {
				return result.concat([element[3]])
			}, [ head ]),
			txt: () => computeText(arguments)
		};
    }
	
loadBlockGroupByField
	= resource
	
loadBlockOrderByFields
	= head:loadBlockOrderByField tail:(sep? ',' sep? loadBlockOrderByField)*
	{
		return {
			fields: tail.reduce(function(result, element) {
				return result.concat([element[3]])
			}, [ head ]),
			txt: () => computeText(arguments)
		}
    }
	
loadBlockOrderByField
	= $ resource (sep ('ASC'i / 'DESC'i))?
