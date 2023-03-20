/*
 * Expressions
 */

expressions
	= head:expression tail:(sep? ',' sep? expression?)*
	{
		return tail.reduce(function(result, element) {
			return result.concat([element[3]])
		}, [ head ]);
    }
	
expression
	= expr:conditionORExpression
	{
		return expr;
	}
	
// OR has a lower priority so rule evaluation is 1st in order
	
conditionORExpression
	= head:conditionANDExpression tail:(sep? conditionOROperator sep? conditionANDExpression)*
	{
		if (tail.length == 0) {
			return head;
		} else {
			var retVal = tail.reduce(function(result, element) {
				return { type: 'EXPR', op: element[1], left: result, right: element[3]}
			}, head)
			retVal.txt = () => computeText(arguments);
			return retVal;
		}
    }

conditionOROperator		= op: ( 'OR'i / 'XOR'i ) & ( sep / '(' ) 			{ return op; }

// AND has a higher priority so rule evaluation is 2nd in order

conditionANDExpression
	= head:conditionNOTExpression tail:(sep? conditionANDOperator sep? conditionNOTExpression)*
	{
		if (tail.length == 0) {
			return head;
		} else {
			var retVal = tail.reduce(function(result, element) {
				return { type: 'EXPR', op: element[1], left: result, right: element[3]}
			}, head)
			retVal.txt = () => computeText(arguments);
			return retVal;
		}
    }
	
conditionANDOperator	= op:'AND'i & ( sep / '(' ) 						{ return op; }

// NOT has a higher priority so rule evaluation is last in order
	
conditionNOTExpression
	= tail:(conditionNOTOperator sep? comparisonExpression)+
	{
		var retVal = tail.reduce(function(result, element) {
			return { type: 'EXPR', op: element[0], left: element[2], right: false}
		}, [])
		retVal.txt = () => computeText(arguments);
		return retVal;
    }
	/ comparisonExpression

conditionNOTOperator		= op:'NOT'i & ( sep / '(' )						{ return op; }

comparisonExpression
	= left:calculationExpression sep? op:comparisonOperator sep? right:calculationExpression {
		return { type: 'EXPR', op: op, left: left, right: right, txt: () => computeText(arguments) }
    }
	/ left:calculationExpression { return left; }

comparisonOperator	= '=' / '<>' / '>=' / '<=' / '>' / '<' / 'LIKE'i & sep

calculationExpression
	= calculationStringExpression
	
calculationStringExpression
	= head:calculationAddExpression tail:(sep? calculationStringOperator sep? calculationAddExpression)*
	{
		if (tail.length == 0) {
			return head;
		} else {
			var retVal = tail.reduce(function(result, element) {
				return { type: 'EXPR', op: element[1], left: result, right: element[3]}
			}, head);
			retVal.txt = () => computeText(arguments);
			return retVal;
		}
    }
	
calculationStringOperator = '&'
	
calculationAddExpression
	= head:calculationFactExpression tail:(sep? calculationAddOperator sep? calculationFactExpression)*
	{
		if (tail.length == 0) {
			return head;
		} else {
			var retVal = tail.reduce(function(result, element) {
				return { type: 'EXPR', op: element[1], left: result, right: element[3]}
			}, head);
			retVal.txt = () => computeText(arguments);
			return retVal;
		}
    }
	
calculationAddOperator = '+' / '-'
	
calculationFactExpression
	= head:termExpression tail:(sep? calculationFactOperator sep? termExpression)*
	{
		if (tail.length == 0) {
			return head;
		} else {
			var retVal = tail.reduce(function(result, element) {
				return { type: 'EXPR', op: element[1], left: result, right: element[3]}
			}, head);
			retVal.txt = () => computeText(arguments);
			return retVal;
		}
    }

calculationFactOperator = ((! (connectBlock / '*' sep '*')) '*' ) / '/'
  
termExpression
	= op:"(" sp1:sep? expr:expression sp2:sep? cp:")"		{ return { type: 'EXPR', op: false, left: expr, right: false, 	txt: () => computeText(arguments) }; }
	/ expr:number											{ return { type: 'NUM', value: expr, 							txt: () => computeText(arguments) }; }	
	/ expr:singleQuoteString								{ return expr; }
	/ expr:functionCall										{ return expr; }
	/ expr:('TRUE'i / 'FALSE'i)								{ return { type: 'BOOL', value: expr, 							txt: () => computeText(arguments) }; }
	/ expr:resource											{ return { type: 'VAR', value: expr.value, 						txt: () => computeText(arguments) }; }
	/ expr:('$' [0-9])										{ return { type: 'PARAM', value: expr, 							txt: () => computeText(arguments) }; }
