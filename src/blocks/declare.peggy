// DECLARE block

declareBlock					=
	table:	(tableName 														sep)
	head:	('DECLARE FIELD DEFINITION TAGGED'i spaces ( '(' singleQuoteString ')' / singleQuoteString )	sep)
	params:	(
				'Parameters'i												sep
				variableName spaces? '=' spaces? variableValue				sep
	) ?
	fields:	(
				'Fields'i													sep
				declareBlockFields
	)
	{
		return false;
	}
	
declareBlockFields
	= head:declareBlockField tail:(sep? ',' sep? declareBlockField)*
	{
		return tail.reduce(function(result, element) {
			return result.concat([element[3]])
		}, [ head ]);
    }
	
declareBlockField
	= '*'
	/ expr:expression as:(sep 'AS'i sep resource (sep 'TAGGED'i (spaces singleQuoteString / spaces? '(' singleQuoteStrings ')'))?)?
	{
		return {
			expr: expr,
			field: (as && as[3]) ? as[3] : expr.value
		}
	}
