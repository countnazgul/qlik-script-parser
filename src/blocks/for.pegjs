// FOR block

forBlock
	= 'FOR'i spaces variable:resource spaces '=' spaces from:expression spaces 'TO'i spaces to:expression step:(spaces 'STEP'i spaces expression)?
	{
		return {
			each: false,
			variable: variable,
			from: from,
			to: to,
			step: step ? step[3] : false
		};
	}
	/
	'FOR'i spaces 'EACH'i spaces variable:resource spaces 'IN'i spaces inexp:forEachBlockIns
	{
		return {
			each: true,
			variable: variable,
			inexp: inexp
		};
	}
	
forEachBlockIns
	= head:forEachBlockIn tail:(sep? ',' sep? forEachBlockIn)*
	{
		return tail.reduce(function(result, element) {
			return result.concat([element[3]])
		}, [ head ]);
    }
	
forEachBlockIn
	= expr:string																{ return { type: 'STR', value: expr }; }
	/ name:'FILELIST'i spaces? '(' spaces? mask:expression spaces? ')'			{ return { type: "FCALL", function: name, params: [ mask ] }; }
	/ name:'DIRLIST'i spaces? '(' spaces? mask:expression spaces? ')'			{ return { type: "FCALL", function: name, params: [ mask ] }; }
	/ name:'FIELDVALUELIST'i spaces? '(' spaces? mask:expression spaces? ')'	{ return { type: "FCALL", function: name, params: [ mask ] }; }
    / expr:expression															{ return { type: 'EXPR', value: expr }; }
	
