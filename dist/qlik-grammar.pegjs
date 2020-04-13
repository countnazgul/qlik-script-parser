
// Base script used from https://github.com/pouc/qlik-script-log-parser

{
	function isFunction(functionToCheck) {
		var getType = {};
		return functionToCheck && getType.toString.call(functionToCheck) === '[object Function]';
	}
	
	function sortArgs(args) {
		return Array.prototype.slice.call(args);
	}
	
	function computeTextUnit(arrgs) {
	
		if (typeof arrgs === 'undefined') return '';
		else if (Array.isArray(arrgs)) return arrgs.map(arg => computeTextUnit(arg)).join('');
		else if (arrgs !== null && typeof arrgs === 'object' && arrgs.hasOwnProperty('txt') && isFunction(arrgs.txt)) return arrgs.txt();
		else if (arrgs !== null && typeof arrgs === 'object' && (!arrgs.hasOwnProperty('txt') || isFunction(arrgs.txt))) return '';
		else if (arrgs !== null && typeof arrgs !== 'object') return '' + arrgs;
		else return '';

	}

	function computeText(args) {
		return computeTextUnit(sortArgs(args));
	}
}


QlikLogFile
	= blocks

blocks
	= '\ufeff'? head:block tail:(newline block spaces? )* {
		return {
			blocks: tail.reduce(function(result, element) {
				if(element[1] !== null) return result.concat([element[1]]);
				else return result;
			}, [ head ]),
			txt: () => computeText(arguments)
		}
	}
   
// TODO
// - ALIAS
// - DIRECTORY
// - EXECUTE
// - FLUSHLOG
// - FORCE
// - LOOSEN
// - MAP
// - NULLASNULL
// - NULLASVALUE
// - REM - done
// - SQLCOLUMNS
// - SQLTABLES
// - SQLTYPES
// - UNMAP
// - UNTAG
// - SWITCH 
  
block
	= txt:($ spaces?) & spEndofrow
	{
		return {
			blockType: 'EMPTY',
			txt: () => computeText(arguments)
		};
	}

	/ tab:tabBlock & spEndofrow
	{
		return {
			blockType: 'TAB',
			block: tab,
			txt: () => computeText(arguments)
		};
	}	
	
	/ comment:scriptCommentBlock & spEndofrow
	{
		return {
			blockType: 'COMMENT',
			block: comment,
			txt: () => computeText(arguments)
		};
	}
	
	/ connectBlock:connectBlock & spEndofrow
	{
		return {
			blockType: 'CONNECT',
			block: connectBlock,
			txt: () => computeText(arguments)
		};
	}
	
	/ hiddenBlock:hiddenBlock & spEndofrow
	{
		return {
			blockType: 'HIDDEN',
			block: hiddenBlock,
			txt: () => computeText(arguments)
		};
	}
	
	/ traceBlock:traceBlock & spEndofrow
	{
		return {
			blockType: 'TRACE',
			block: traceBlock,
			txt: () => computeText(arguments)
		};
	}
	
	/ block:whenBlock & spEndofrow
	{
		return block;
	}
	
	/ block:blockContent & spEndofrow
	{
		return {
			blockType: block.type,
			block: block.block,
			txt: () => computeText(arguments)
		};
	}
	
	/ unknownBlock:unknownBlock & spEndofrow
	{
		return {
			blockType: 'UNKNOWN',
			unknown: unknownBlock,
			txt: () => computeText(arguments)
		};
	}
	
	
blockContent		=
	block:letSetBlock			{ return { type: 'LET SET',		block: block, txt: () => computeText(arguments) }; }
	/	block:ifBlock			{ return { type: 'IF',			block: block, txt: () => computeText(arguments) }; }
	/	block:elseBlock			{ return { type: 'ELSE',		block: block, txt: () => computeText(arguments) }; }
	/	block:endBlock			{ return { type: 'END',			block: block, txt: () => computeText(arguments) }; }
	/	block:loadBlock			{ return { type: 'LOAD',		block: block, txt: () => computeText(arguments) }; }
	/	block:dropBlock			{ return { type: 'DROP',		block: block, txt: () => computeText(arguments) }; }
	/	block:renameBlock		{ return { type: 'RENAME',		block: block, txt: () => computeText(arguments) }; }
	/	block:doBlock			{ return { type: 'DO',			block: block, txt: () => computeText(arguments) }; }
	/	block:loopUntilBlock	{ return { type: 'LOOP UNTIL',	block: block, txt: () => computeText(arguments) }; }
	/	block:exitBlock			{ return { type: 'EXIT',		block: block, txt: () => computeText(arguments) }; }
	/	block:declareBlock		{ return { type: 'DECLARE',		block: block, txt: () => computeText(arguments) }; }
	/	block:deriveBlock		{ return { type: 'DERIVE',		block: block, txt: () => computeText(arguments) }; }
	/	block:forBlock			{ return { type: 'FOR',			block: block, txt: () => computeText(arguments) }; }
	/	block:nextBlock			{ return { type: 'NEXT',		block: block, txt: () => computeText(arguments) }; }
	/	block:storeBlock		{ return { type: 'STORE',		block: block, txt: () => computeText(arguments) }; }
	/	block:sleepBlock		{ return { type: 'SLEEP',		block: block, txt: () => computeText(arguments) }; }
	/	block:binaryBlock		{ return { type: 'BINARY',		block: block, txt: () => computeText(arguments) }; }
	/	block:searchBlock		{ return { type: 'SEARCH',		block: block, txt: () => computeText(arguments) }; }
	/	block:subBlock			{ return { type: 'SUB',			block: block, txt: () => computeText(arguments) }; }
	/	block:callBlock			{ return { type: 'CALL',		block: block, txt: () => computeText(arguments) }; }
	/	block:starIsBlock		{ return { type: 'STAR IS',		block: block, txt: () => computeText(arguments) }; }
	/	block:sectionBlock		{ return { type: 'SECTION',		block: block, txt: () => computeText(arguments) }; }
	/	block:commentBlock		{ return { type: 'COMMENT',		block: block, txt: () => computeText(arguments) }; }
	/	block:tagBlock			{ return { type: 'TAG',			block: block, txt: () => computeText(arguments) }; }
	/	block:qualifyBlock		{ return { type: 'QUALIFY',		block: block, txt: () => computeText(arguments) }; }
	/	block:directBlock		{ return { type: 'DIRECT',		block: block, txt: () => computeText(arguments) }; }














	

	

	
	








// UNKNOWN

unknownBlock		= endofrow

// WHEN

whenBlock
	= when:'WHEN'i sp1:spaces cond:expression sp2:spaces statement:blockContent
	{
		
		statement.when = cond;
		statement.txt = () => computeText(arguments);
		return statement;
	}


// HIDDEN

hiddenBlock			= $ (('*' / ' ' / ',')+ & spEndofrow)
// CONNECT

connectBlock
	= con1:connectBlockSep* head:connectBlockItem con2:connectBlockSep* tail:(connectBlockItem connectBlockSep*)* & spEndofrow
	{
	
		var retVal = [ head ].concat(tail.map(val => val[0])).reduce((result, val) => {
			if(result == -1) return -1;
			if(result == 0) {
				if(typeof val.connect == 'undefined') return result;
				if(val.connect == true) return true;
				if(val.connect == false) return false;
			}
			if(result == true) {
				if(typeof val.connect == 'undefined') return result;
				if(val.connect == true) return true;
				if(val.connect == false) return -1;
			}
			if(result == false) {
				if(typeof val.connect == 'undefined') return result;
				if(val.connect == true) return -1;
				if(val.connect == false) return false;
			}
		}, 0)
		
		return { connect: retVal, txt: () => computeText(arguments) };
	}


connectBlockItem
	= c:'CONNECT'i to:(spaces 'TO'i)?	{ return { connect: true, 		txt: () => computeText(arguments) } }
	/ c:'CUSTOM'i						{ return { connect: true, 		txt: () => computeText(arguments) } }
	/ d:'DISCONNECT'i					{ return { connect: false, 		txt: () => computeText(arguments) } }
	/ p:'PROVIDER'i						{ return { connect: undefined, 	txt: () => computeText(arguments) } }
	
connectBlockSep		= ' ' / '*'


// DIRECT

directBlock			=
		tbl:( tableName sep? )?
		dir:( 'DIRECT'i sep 'QUERY'i )
		dim:( sep 'DIMENSION'i sep directBlockFields )
		mea:( sep 'MEASURE'i sep directBlockFields )?
		dtl:( sep 'DETAIL'i sep resources )?
		frm:( sep 'FROM'i sep endofrow )
		whr:( sep 'WHERE'i sep directBlockWhere )?
		{
			return {
				dimension: dim[3].fields,
				measure: mea ? mea[3].fields : false,
				detail: dtl ? dtl[3] : false,
				from: frm[3],
				where: whr ? whr[3] : false,
				txt: () => computeText(arguments)
			}
		}
		
directBlockFields
	= head:directBlockField tail:(sep? ',' sep? directBlockField)*
	{ return { fields: [ head ].concat(tail ? tail.map(e => e[3]) : []), txt: () => computeText(arguments) } }
	
directBlockField
	= src:(directBlockNative / resource) sep1:sep as:'AS'i sep2:sep res:resource
	{ return { expr: src, field: res, txt: () => computeText(arguments) }; }
	/ resource

directBlockWhere	= directBlockNative

directBlockNative
	= native:'NATIVE'i sep1:sep? op:'(' sep2:sep? str:string sep3:sep? cp:')'
	{ return { type: 'NATIVE', value: str, txt: () => computeText(arguments) }; }



// QUALIFY

qualifyBlock
	= un:('UN'i)? qua:'QUALIFY'i sep:sep fields:searchBlockFields
	{
		return {
			unqualify: un ? true : false,
			fields : fields,
			txt: () => computeText(arguments)
		}
	}

// STAR IS

starIsBlock
	= $ 'STAR'i spaces 'IS'i spaces endofrow


// SECTION

sectionBlock
	= $ 'SECTION'i spaces endofrow



// SUB & CALL

subBlock
	= sub:'SUB'i sep1:sep name:resource params:( sep? '(' params:resources ')' { return params; } )?
	{ return { name: name, params: params, txt: () => computeText(arguments) }; }
	
callBlock
	= cal:'CALL'i sep1:sep name:resource params:( sep? '(' params:expressions ')' { return params; } )?
	{ return { name: name, params: params, txt: () => computeText(arguments) }; }



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


// TAG

tagBlock
	= t:'TAG'i sep1:sep f:('FIELD'i sep)? res:resource sep2:sep w:'WITH'i sep3:sep tag:(string / $ ('$' resource))
	{ return { mode: 'SINGLE', resource: res, tag: tag, txt: () => computeText(arguments) } }
	/ t:'TAG'i sep1:sep f:'FIELDS'i sep2:sep res:resources sep3:sep u:'USING'i sep4:sep map:resource
	{ return { mode: 'MAP', resources: res, map: map, txt: () => computeText(arguments) } }


// TAB - ///$tab Main\r\n

tabBlock
	= '///$tab' sp:sep? res:resources
      { return { name: res, txt: () => computeText(arguments) } }
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


// LET/SET block
letSetBlock = letset:('LET'i sep / 'SET'i sep)? sep1:sep? name:variableName sep3:sep* eq:'='  sep2:sep* value:letSetBlockValue sep* ';'
	{ return {
		type: letset ? letset[0] : 'LET',
		name: name,
		value: value.val,
		txt: () => computeText(arguments)
	}}
	
letSetBlockValue
	= & (sep? variableValue  sep? ';' spEndofrow ( EOF / block )) sep3:sep? val:variableValue	{ return { val: val, txt: () => computeText(arguments) } }
	/ val:spaces? & spEndofrow														{ return { val: val, txt: () => computeText(arguments) } }

// letSetBlockValue
// 	= & (sep? variableValue spEndofrow ( EOF / block )) sep3:sep? val:variableValue	{ return { val: val, txt: () => computeText(arguments) } }
// 	/ val:spaces? & spEndofrow	
// IF block

ifBlock				=
	e:('ELSE'i spaces?)? i:'IF'i sp1:spaces condition:expression sp2:spaces t:'THEN'i
	{ return { condition: condition, txt: () => computeText(arguments) } } 


// LOAD block

loadBlock           = lb:loadBlockInner sep? ';' {return lb}

loadBlockInner	    =
	
	// PRECEDING LOAD + SUFFIXES + LOAD BLOCK

    precedings:	(loadBlockPrecedings	sep)
    prefixes:	(loadBlockPrefixes		sep)?
    load:		(loadBlockLoad			sep)
    source:		(loadBlockSource		sep)
    suffixes:	(loadBlockSuffixes		sep? newline)
    // summary:	(loadBlockSum			)
	
    {
    	return {
				precedings:				precedings[0].precedings,
				prefixes: 				prefixes ? prefixes[0].prefixes : false,
				load:					load[0],
				source:					source[0],
				suffixes:				suffixes[0].suffixes,
				// summary:				summary,
				txt:					() => computeText(arguments)
        };
    }
	
	/ // SUFFIXES + LOAD BLOCK

    prefixes:	(loadBlockPrefixes		sep)?
    load:		(loadBlockLoad			sep)
    source:		(loadBlockSource		sep)
    suffixes:	(loadBlockSuffixes		sep? newline)
    // summary:	(loadBlockSum			)
	
    {
    	return {
				prefixes: 				prefixes ? prefixes[0].prefixes : false,
				load:					load[0],
				source:					source[0],
				suffixes:				suffixes[0].suffixes,
				// summary:				summary,
				txt:					() => computeText(arguments)
        };
    }
	
	/ // PRECEDING LOAD + LOAD BLOCK

    precedings:	(loadBlockPrecedings	sep)
    prefixes:	(loadBlockPrefixes		sep)?
    load:		(loadBlockLoad			sep)
    source:		(loadBlockSource		sep? newline)
    // summary:	(loadBlockSum			)

    {
    	return {
				precedings:				precedings[0].precedings,
				prefixes: 				prefixes ? prefixes[0].prefixes : false,
				load:					load[0],
				source:					source[0],
				// summary:				summary,
				txt:					() => computeText(arguments)
        };
    }
	
	/ // LOAD BLOCK

    prefixes:	(loadBlockPrefixes		sep)?
    load:		(loadBlockLoad			sep)
    source:		(loadBlockSource		sep?)
	suffixes:	(loadBlockSuffixes		sep?)?
    // summary:	(loadBlockSum			)
	
    {
    	return {
				prefixes: 				prefixes ? prefixes[0].prefixes : false,
				load:					load[0],
				source:					source[0],
				// summary:				summary,
				txt:					() => computeText(arguments)
        };
    }
	
	/ // PRECEDING LOAD + SUFFIXES + SQL BLOCK
	
	precedings:	(loadBlockPrecedings	sep)
	prefixes:	(loadBlockPrefixes		sep)?
	source:		(loadBlockSourceSQL		sep)
	suffixes:	(loadBlockSuffixes		sep? newline)
	// summary:	(loadBlockSum			)
	
	{
    	return {
				precedings:				precedings[0].precedings,
				prefixes: 				prefixes ? prefixes[0].prefixes : false,
				source:					source[0],
				suffixes:				suffixes[0].suffixes,
				// summary:				summary,
				txt:					() => computeText(arguments)
        };
    }
	
	/ // SUFFIXES + SQL BLOCK
	
	prefixes:	(loadBlockPrefixes		sep)?
	source:		(loadBlockSourceSQL		sep)
	suffixes:	(loadBlockSuffixes		sep? newline)
	// summary:	(loadBlockSum			)
	
	{
    	return {
				prefixes: 				prefixes ? prefixes[0].prefixes : false,
				source:					source[0],
				suffixes:				suffixes[0].suffixes,
				// summary:				summary,
				txt:					() => computeText(arguments)
        };
    }
	
	/ // PRECEDING LOAD + SQL BLOCK
	
	precedings:	(loadBlockPrecedings	sep)
	prefixes:	(loadBlockPrefixes		sep)?
	source:		(loadBlockSourceSQL		sep? newline)
	// summary:	(loadBlockSum			)
	
	{
    	return {
				precedings:				precedings[0].precedings,
				prefixes: 				prefixes ? prefixes[0].prefixes : false,
				source:					source[0],
				// summary:				summary,
				txt:					() => computeText(arguments)
        };
    }
	
	/ // SQL BLOCK
	
	prefixes:	(loadBlockPrefixes		sep)?
	source:		(loadBlockSourceSQL		sep? newline)
	// summary:	(loadBlockSum			)
	
	{
    	return {
				prefixes: 				prefixes ? prefixes[0].prefixes : false,
				source:					source[0],
				// summary:				summary,
				txt:					() => computeText(arguments)
        };
    }
	
	/
	
	// PRECEDING LOAD + SUFFIXES + LOAD BLOCK NOSOURCE

    precedings:	(loadBlockPrecedings	sep)
    prefixes:	(loadBlockPrefixes		sep)?
    load:		(loadBlockLoad			sep)
    suffixes:	(loadBlockSuffixes		)
	
    {
    	return {
				precedings:				precedings[0].precedings,
				prefixes: 				prefixes ? prefixes[0].prefixes : false,
				load:					load[0],
				suffixes:				suffixes.suffixes,
				txt:					() => computeText(arguments)
        };
    }
	
	/ // SUFFIXES + LOAD BLOCK NOSOURCE

    prefixes:	(loadBlockPrefixes		sep)?
    load:		(loadBlockLoad			sep)
    suffixes:	(loadBlockSuffixes		)
	
    {
    	return {
				prefixes: 				prefixes ? prefixes[0].prefixes : false,
				load:					load[0],
				suffixes:				suffixes.suffixes,
				txt:					() => computeText(arguments)
        };
    }
	
	/ // PRECEDING LOAD + LOAD BLOCK NOSOURCE

    precedings:	(loadBlockPrecedings	sep)
    prefixes:	(loadBlockPrefixes		sep)?
    load:		(loadBlockLoad			)

    {
    	return {
				precedings:				precedings[0].precedings,
				prefixes: 				prefixes ? prefixes[0].prefixes : false,
				load:					load,
				txt:					() => computeText(arguments)
        };
    }
	
	/ // LOAD BLOCK NOSOURCE

    prefixes:	(loadBlockPrefixes		sep)?
    load:		(loadBlockLoad			)
	
    {
    	return {
				prefixes: 				prefixes ? prefixes[0].prefixes : false,
				load:					load,
				txt:					() => computeText(arguments)
        };
    }
	
loadBlockPrecedings
	= head:loadBlockPreceding tail:(sep? loadBlockPreceding)*
	{
		return {
			precedings: tail.reduce(function(result, element) {
				return result.concat([element[1]])
			}, [ head ]),
			txt: () => computeText(arguments)
		};
		
    }

loadBlockPreceding 
	= prefixes:	(loadBlockPrefixes	sep)?
	load:		(loadBlockLoad		sep)
	suffixes:	(loadBlockSuffixes	)
	& (sep? loadBlock)
	
	{
		return {
				prefixes:			prefixes ? prefixes[0].prefixes : false,
				load:				load[0],
				suffixes:			suffixes.suffixes,
				txt:				() => computeText(arguments)
		};
	}
	
	/
	
	prefixes:	(loadBlockPrefixes	sep)?
	load:		(loadBlockLoad		)
	& (sep? loadBlock)
	
	{
		return {
				prefixes:			prefixes ? prefixes[0].prefixes : false,
				load:				load,
				txt:				() => computeText(arguments)
		};
	}
	
	


// PREFIXES
	
loadBlockPrefixes
	= head:loadBlockPrefix tail:(sep? loadBlockPrefix)*
	{
		return {
			prefixes: tail.reduce(function(result, element) {
				Object.keys(element[1]).forEach(key => result[key] = element[1][key])
				return result;
			}, head),
			txt: () => computeText(arguments)
		};
    }

	
// TODO
// - Handle generic summary
// - KEEP
// - REPLACE
// - SAMPLE
// - SEMANTIC
// - UNLESS
	
loadBlockPrefix
	= prefix:tableName						{ return { table: prefix,				txt:		() => computeText(arguments) } }
	/ prefix:'MAPPING'i & sep				{ return { mapping: true,					txt:		() => computeText(arguments) } }
	/ prefix:loadBlockConcat				{ return { concat: prefix,					txt:		() => computeText(arguments) } }
	/ prefix:loadBlockJoin					{ return { join: prefix,					txt:		() => computeText(arguments) } }
	/ prefix:loadBlockInterval				{ return { interval: prefix,				txt:		() => computeText(arguments) } }
	/ prefix:loadBlockAdd					{ return { add: prefix,						txt:		() => computeText(arguments) } }
	/ prefix:loadBlockBuffer				{ return { buffer: prefix,					txt:		() => computeText(arguments) } }
	/ prefix:loadBlockBundle				{ return { bundle: prefix,					txt:		() => computeText(arguments) } }
	/ prefix:loadBlockCrosstable			{ return { crosstable: prefix,				txt:		() => computeText(arguments) } }
	/ prefix:loadBlockFirst					{ return { first: prefix,					txt:		() => computeText(arguments) } }
	/ prefix:'GENERIC'i & sep				{ return { generic: true,					txt:		() => computeText(arguments) } }
	/ prefix:loadBockHierarchy				{ return { hierarchy: prefix,				txt:		() => computeText(arguments) } }
	/ prefix:loadBockHierarchyBelongsTo		{ return { hierarchyBelongsTo: prefix,		txt:		() => computeText(arguments) } }

loadBlockConcat
	= concat:'CONCATENATE'i name:(
      	sep1:sep? op:'(' sep2:sep? name:resource sep3:sep? cp:')'		{ return { name: name, 					txt:		() => computeText(arguments) }}
        / & sep															{ return { name: false, 				txt:		() => computeText(arguments) }}
    )																{ return { concat: true, name: name.name, 	txt:		() => computeText(arguments) }}
	/ noconcat:'NOCONCATENATE'i & sep								{ return { concat: false, 					txt:		() => computeText(arguments) }}
	
loadBlockJoin
	= dir:(
		'LEFT'i sep
		/ 'RIGHT'i sep
		/ 'INNER'i sep
		/ 'OUTER'i sep
	)? j:'JOIN'i name:loadBlockJoinName
	{ return { join: true, direction: dir ? dir[0] : false, name: name.name, txt: () => computeText(arguments) } }
	
loadBlockJoinName
	= sep1:sep? op:'(' sep2:sep? name:resource sep3:sep? cp:')'	{ return { name: name,	txt: () => computeText(arguments) } }
	/ & sep														{ return { name: false,	txt: () => '' } }
	
loadBlockInterval
	= i:'INTERVALMATCH'i sep1:sep? op:'(' sep2:sep? name:resource sep3:sep? cp:')'
	{ return { name: name, txt: () => computeText(arguments) } }
	
loadBlockAdd
	= a:'ADD'i only:(sep 'ONLY'i)? & sep
	{ return { add: true, only: (only) ? true : false, txt: () => computeText(arguments) } }
	
loadBlockBuffer
	= b:'BUFFER'i bp:(
		sep? '(' sep? options:loadBlockBufferOptions sep? ')'
		/ & sep
	)
	{ return { buffer: true, options: options.options, txt: () => computeText(arguments) } }
	
loadBlockBufferOptions
	= head:loadBlockBufferOption tail:(sep? ',' sep? loadBlockBufferOption)*
	{
		return {
			options: tail.reduce(function(result, element) {
				Object.keys(element[1]).forEach(key => result[key] = element[1][key])
				return result;
			}, head),
			txt: () => computeText(arguments)
		}
    }
	
loadBlockBufferOption
	= i:'INCREMENTAL'i
	{ return { incremental: true, txt: () => computeText(arguments) }; }
	/ s:'STALE'i after:( sep 'AFTER'i )? sep1:sep duration:integer unit:( sep ( 'DAYS'i / 'HOURS'i ))?
	{ return { stale: true, after: (after) ? true : false, duration: duration, unit: (unit) ? unit[1] : 'DAYS', txt: () => computeText(arguments) } }

loadBlockBundle
	= $ 'BUNDLE'i ( sep 'INFO'i )? & sep
	
loadBlockCrosstable
	= c:'CROSSTABLE'i sep1:sep? op:'('
	sep2:sep? attribute:resource sep3:sep? c1:','
	sep4:sep? data:resource sep5:sep? n:( ','
	sep? integer sep? )?
	cp:')'
	{
		return {
			attribute: attribute,
			data: data,
			n: (n) ? n[2] : false,
			txt: () => computeText(arguments)
		}
	}
	
loadBlockFirst
	= f:'FIRST'i n:loadBlockFirstN
	{ return { first: n.n, txt: () => computeText(arguments) } }
	
loadBlockFirstN
	= sep1:sep n:integer										{ return { n: n, txt: () => computeText(arguments) } }
	/ sep1:sep? op:'(' sep2:sep? n:integer sep3:sep? cp:')'		{ return { n: n, txt: () => computeText(arguments) } }
	
loadBockHierarchy
	= h:'HIERARCHY'i s0:sep? op:'(' s1:sep?
		nodeId:loadBockHierarchyResSep
		parentId:loadBockHierarchyResSepComma
		nodeName:loadBockHierarchyResSepComma
		parentName:loadBockHierarchyResSepComma?
		pathSource:loadBockHierarchyResSepComma?
		pathName:loadBockHierarchyResSepComma?
		pathDelimiter:loadBockHierarchyResSepComma?
		depth:loadBockHierarchyResSepComma?
	cp:')'
	{
		return {
			nodeId:			nodeId.res,
			parentId:		parentId.res,
			nodeName:		nodeName.res,
			parentName:		(parentName) ? parentName.res : false,
			pathSource:		(pathSource) ? pathSource.res : false,
			pathName:		(pathName) ? pathName.res : false,
			pathDelimiter:	(pathDelimiter) ? pathDelimiter.res : false,
			depth:			(depth) ? depth.res : false,
			txt:			() => computeText(arguments)
		}
	}

loadBockHierarchyResSep
	= res:resource s:sep?
	{ return { res: res, txt: () => computeText(arguments) }}
	
loadBockHierarchyResSepComma
	= c:',' s:sep? res:loadBockHierarchyResSep?
	{ return { res: res ? res.res : false, txt: () => computeText(arguments) }}
	
loadBockHierarchyBelongsTo
	= h:'HIERARCHYBELONGSTO'i s0:sep? op:'(' s1:sep?
		nodeId:loadBockHierarchyResSep
		parentId:loadBockHierarchyResSepComma
		nodeName:loadBockHierarchyResSepComma
		ancestorId:loadBockHierarchyResSepComma
		ancestorName:loadBockHierarchyResSepComma
		depthDiff:loadBockHierarchyResSepComma?
	cp:')'
	{
		return {
			nodeId:			nodeId.res,
			parentId:		parentId.res,
			nodeName:		nodeName.res,
			ancestorId:		ancestorId.res,
			ancestorName:	ancestorName.res,
			depthDiff:		(depthDiff) ? depthDiff.res : false,
			txt:			() => computeText(arguments)
		}
	}

	

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

// TRACE block. Single & multiple rows are handled
traceBlock = "TRACE"i (spaces / newline) inner:(!";" i:. {return i})*  ';'
				{ 
					return { 
						trace: inner.join(''), 
						txt: () => computeText(arguments) 
					}
				}


// DROP block

dropBlock
	= d:'DROP'i s1:sep type:('FIELD'i / 'TABLE'i) s:('S'i)? s2:sep resources:resources ';'/*from:dropBlockFrom?*/
	{
		return {
			type: type,
			drop: resources,
			// from: from ? from.res : false,
			txt: () => computeText(arguments)
		}
	}
	
dropBlockFrom
	= s3:sep f:'FROM'i s4:sep res:resources
	{ return { res: res, txt: () => computeText(arguments) }}


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


// DO block

doBlock
	= 'DO'i w:doBlockWhile?
	{ return { while: w ? w.expr : false, txt: () => computeText(arguments) }}
	
doBlockWhile
	= s1:sep w:'WHILE'i s2:sep expr:expression
	{ return { expr: expr, txt: () => computeText(arguments) }}
// LOOP UNTIL block

loopUntilBlock					= 'LOOP'i until:(sep 'UNTIL'i sep condition:expression { return condition })? { return { until: until ? until : false }; }

// EXIT block

exitBlock						= 'EXIT'i (sep ('DO'i / 'SCRIPT'i))?
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

// DERIVE block

deriveBlock						= 'DERIVE'i sep 'FIELDS'i spaces endofrow { return false; }

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
	

// NEXT block

nextBlock 						= 'NEXT'i (spaces resource)? { return false; }
// ELSE block

elseBlock 						= 'ELSE'i { return false; }
// END block

endBlock 						= 'END'i spaces? end:( 'IF'i / 'SUB'i ) { return false; }
// STORE block

storeBlock 
	= 'STORE'i sep res:resource sep 'INTO'i sep into:resource params:(sep? '(' sep? params:loadBlockSourceFromParams sep? ')' { return params; })?
	{
		return {
			res: res,
			into: into,
			params: params ? params : false
		}
	}



// SLEEP block

sleepBlock						= 'SLEEP'i spaces sleep:integer { return sleep; }
// BINARY block

binaryBlock						= 'BINARY'i spaces bin:resource { return bin; }
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

functionCall		= 	name:functionName sp1:sep? op:'(' sp2:sep? d:'DISTINCT'i? sp3:sep? params:functionParameters? sp4:sep? cp:')'
						{ return { type: "FCALL", function: name, params: params, txt: () => computeText(arguments) }; }

fp					= & (sep? '(')

functionName					 	
/* Aggregation					*/	= func:(
									  'FirstSortedValue'i fp	/ 'Min'i fp					/ 'Max'i fp					/ 'Mode'i fp				/ 'Only'i fp
									/ 'Sum'i fp					/ 'Count'i fp				/ 'MissingCount'i fp		/ 'NullCount'i fp			/ 'NumericCount'i fp
									/ 'TextCount'i fp			/ 'IRR'i fp					/ 'XIRR'i fp				/ 'NPV'i fp					/ 'XNPV'i fp
									/ 'Avg'i fp					/ 'Correl'i fp				/ 'Fractile'i fp			/ 'Kurtosis'i fp			/ 'LINEST_B'i fp
									/ 'LINEST_df'i fp			/ 'LINEST_f'i fp			/ 'LINEST_m'i fp			/ 'LINEST_r2'i fp			/ 'LINEST_seb'i fp
									/ 'LINEST_sem'i fp			/ 'LINEST_sey'i fp			/ 'LINEST_ssreg'i fp		/ 'Linest_ssresid'i fp		/ 'Median'i fp
									/ 'Skew'i fp				/ 'Stdev'i fp				/ 'Sterr'i fp				/ 'STEYX'i fp				/ 'Chi2Test_chi2'i fp
									/ 'Chi2Test_df'i fp			/ 'Chi2Test_p'i fp			/ 'ttest_conf'i fp			/ 'ttest_df'i fp			/ 'ttest_dif'i fp
									/ 'ttest_lower'i fp			/ 'ttest_sig'i fp			/ 'ttest_sterr'i fp			/ 'ttest_t'i fp				/ 'ttest_upper'i fp
									/ 'ztest_conf'i fp			/ 'ztest_dif'i fp			/ 'ztest_sig'i fp			/ 'ztest_sterr'i fp			/ 'ztest_z'i fp
									/ 'ztest_lower'i fp			/ 'ztest_upper'i fp			/ 'Concat'i fp				/ 'FirstValue'i fp			/ 'LastValue'i fp
									/ 'MaxString'i fp			/ 'MinString'i fp
									
/* Color						*/	/ 'ARGB'i fp				/ 'HSL'i fp					/ 'RGB'i fp					/ 'Color'i fp				/ 'Colormix1'i fp
									/ 'Colormix2'i fp			/ 'SysColor'i fp			/ 'ColorMapHue'i fp			/ 'ColorMapJet'i fp
									
/* Conditional					*/	/ 'alt'i fp					/ 'class'i fp				/ 'if'i fp					/ 'match'i fp				/ 'mixmatch'i fp
									/ 'pick'i fp				/ 'wildmatch'i fp
									
/* Counter						*/	/ 'autonumberhash128'i fp	/ 'autonumberhash256'i fp	/ 'autonumber'i fp			/ 'IterNo'i fp				/ 'RecNo'i fp
									/ 'RowNo'i fp
									
/* Date and time				*/	/ 'Date'i fp				/ 'weekyear'i fp			/ 'weekday'i fp				/ 'now'i fp					/ 'today'i fp
									/ 'LocalTime'i fp			/ 'makedate'i fp			/ 'makeweekdate'i fp		/ 'maketime'i fp			/ 'AddMonths'i fp
									/ 'AddYears'i fp			/ 'yeartodate'i fp			/ 'timezone'i fp			/ 'GMT'i fp					/ 'UTC'i fp
									/ 'daylightsaving'i fp		/ 'converttolocaltime'i fp	/ 'setdateyear'i fp			/ 'setdateyearmonth'i fp	/ 'inyeartodate'i fp
									/ 'inyear'i fp				/ 'inquarter'i fp			/ 'inquartertodate'i fp		/ 'inmonth'i fp				/ 'inmonthtodate'i fp
									/ 'inmonths'i fp			/ 'inmonthstodate'i fp		/ 'inweek'i fp				/ 'inweektodate'i fp		/ 'inlunarweek'i fp
									/ 'inlunarweektodate'i fp	/ 'inday'i fp				/ 'indaytotime'i fp			/ 'yearstart'i fp			/ 'yearend'i fp
									/ 'yearname'i fp			/ 'quarterstart'i fp		/ 'quarterend'i fp			/ 'quartername'i fp			/ 'monthstart'i fp
									/ 'monthend'i fp			/ 'monthname'i fp			/ 'monthsstart'i fp			/ 'monthsend'i fp			/ 'monthsname'i fp
									/ 'weekstart'i fp			/ 'weekend'i fp				/ 'weekname'i fp			/ 'lunarweekstart'i fp		/ 'lunarweekend'i fp
									/ 'lunarweekname'i fp		/ 'daystart'i fp			/ 'dayend'i fp				/ 'dayname'i fp				/ 'age'i fp
									/ 'networkdays'i fp			/ 'firstworkdate'i fp		/ 'lastworkdate'i fp		/ 'daynumberofyear'i fp		/ 'daynumberofquarter'i fp
									/ 'second'i fp				/ 'minute'i fp				/ 'hour'i fp				/ 'day'i fp					/ 'week'i fp
									/ 'month'i fp				/ 'year'i fp
									
/* Exponential and logarithmic	*/	/ 'exp'i fp					/ 'log'i fp					/ 'log10'i fp				/ 'pow'i fp					/ 'sqr'i fp
									/ 'sqrt'i fp
									
/* File							*/	/ 'Attribute'i fp			/ 'ConnectString'i fp		/ 'FileBaseName'i fp		/ 'FileDir'i fp				/ 'FileExtension'i fp
									/ 'FileName'i fp			/ 'FilePath'i fp			/ 'FileSize'i fp			/ 'FileTime'i fp			/ 'GetFolderPath'i fp
									/ 'QvdCreateTime'i fp		/ 'QvdFieldName'i fp		/ 'QvdNoOfFields'i fp		/ 'QvdNoOfRecords'i fp		/ 'QvdTableName'i fp

/* Financial					*/	/ 'FV'i fp					/ 'nPer'i fp				/ 'Pmt'i fp					/ 'PV'i fp					/ 'Rate'i fp

/* Formatting					*/	/ 'ApplyCodepage'i fp		/ 'Dual'i fp				/ 'Num'i fp					/ 'Timestamp'i fp			/ 'Time'i fp
									/ 'Interval'i fp			/ 'Money'i fp
									
/* General numeric				*/	/ 'bitcount'i fp			/ 'div'i fp					/ 'fabs'i fp				/ 'fact'i fp				/ 'frac'i fp
									/ 'sign'i fp				/ 'combin'i fp				/ 'permut'i fp				/ 'fmod'i fp				/ 'mod'i fp
									/ 'even'i fp				/ 'odd'i fp					/ 'ceil'i fp				/ 'floor'i fp				/ 'round'i fp
									
/* Geospatial					*/	/ 'GeoAggrGeometry'i fp		/ 'GeoBoundingBox'i fp		/ 'GeoCountVertex'i fp		/ 'GeoInvProjectGeometry'i fp
									/ 'GeoProjectGeometry'i fp	/ 'GeoReduceGeometry'i fp	/ 'GeoGetBoundingBox'i fp	/ 'GeoGetPolygonCenter'i fp
									/ 'GeoMakePoint'i fp		/ 'GeoProject'i fp
									
/* Interpretation				*/	/ 'Date#'i fp				/ 'Interval#'i fp			/ 'Num#'i fp				/ 'Time#'i fp				/ 'Timestamp#'i fp
									/ 'Money#'i fp				/ 'Text'i fp
									
/* Inter-record					*/	/ 'Exists'i fp				/ 'LookUp'i fp				/ 'Peek'i fp				/ 'Previous'i fp			/ 'FieldValue'i fp

/* Logical						*/	/ 'IsNum'i fp				/ 'IsText'i fp

/* Mapping						*/	/ 'ApplyMap'i fp			/ 'MapSubstring'i fp

/* Mathematical					*/	/ 'e'i fp					/ 'false'i fp				/ 'pi'i fp					/ 'rand'i fp				/ 'true'i fp

/* NULL							*/	/ 'isnull'i fp				/ 'null'i fp

/* Range						*/	/ 'RangeMax'i fp			/ 'RangeMaxString'i fp		/ 'RangeMin'i fp			/ 'RangeMinString'i fp		/ 'RangeMode'i fp
									/ 'RangeOnly'i fp			/ 'RangeSum'i fp			/ 'RangeCount'i fp			/ 'RangeMissingCount'i fp	/ 'RangeNullCount'i fp
									/ 'RangeNumericCount'i fp	/ 'RangeTextCount'i fp		/ 'RangeAvg'i fp			/ 'RangeCorrel'i fp			/ 'RangeFractile'i fp
									/ 'RangeKurtosis'i fp		/ 'RangeSkew'i fp			/ 'RangeStdev'i fp			/ 'RangeIRR'i fp			/ 'RangeNPV'i fp
									/ 'RangeXIRR'i fp			/ 'RangeXNPV'i fp
									
/* Ranking in charts			*/	/ 'Rank'i fp				/ 'HRank'i fp

/* Statistical distribution		*/	/ 'CHIDIST'i fp				/ 'CHIINV'i fp				/ 'NORMDIST'i fp			/ 'NORMINV'i fp				/ 'TDIST'i fp
									/ 'TINV'i fp				/ 'FDIST'i fp				/ 'FINV'i fp
									
/* String						*/	/ 'Capitalize'i fp			/ 'Chr'i fp					/ 'Evaluate'i fp			/ 'FindOneOf'i fp			/ 'Hash128'i fp
									/ 'Hash160'i fp				/ 'Hash256'i fp				/ 'Index'i fp				/ 'KeepChar'i fp			/ 'Left'i fp
									/ 'Len'i fp					/ 'Lower'i fp				/ 'LTrim'i fp				/ 'Mid'i fp					/ 'Ord'i fp
									/ 'PurgeChar'i fp			/ 'Repeat'i fp				/ 'Replace'i fp				/ 'Right'i fp				/ 'RTrim'i fp
									/ 'SubField'i fp			/ 'SubStringCount'i fp		/ 'TextBetween'i fp			/ 'Trim'i fp				/ 'Upper'i fp
									
/* System						*/	/ 'Author'i fp				/ 'ClientPlatform'i fp		/ 'ComputerName'i fp		/ 'DocumentName'i fp		/ 'DocumentPath'i fp
									/ 'DocumentTitle'i fp		/ 'GetCollationLocale'i fp	/ 'GetObjectField'i fp		/ 'GetRegistryString'i fp	/ 'IsPartialReload'i fp
									/ 'OSUser'i fp				/ 'ProductVersion'i fp		/ 'ReloadTime'i fp			/ 'StateName'i fp
									
/* Table						*/	/ 'FieldName'i fp			/ 'FieldNumber'i fp			/ 'NoOfFields'i fp			/ 'NoOfRows'i fp			/ 'NoOfTables'i fp
									/ 'TableName'i fp			/ 'TableNumber'i fp
									
/* Trigonometric and hyperbolic	*/	/ 'cos'i fp					/ 'acos'i fp				/ 'sin'i fp					/ 'asin'i fp				/ 'tan'i fp
									/ 'atan'i fp				/ 'atan2'i fp				/ 'cosh'i fp				/ 'sinh'i fp				/ 'tanh'i fp
								) { return func[0]; }

functionParameters
	= expressions


/*
 * Misc.
 */

blockEnd           = block:(sep? ';' sep?) { return block } // generic block end ;
blockEndSameLine   = block:(spaces? ';') { return block } // the ; should be on the same line. For example: rem comment;

// TODO - need validation
sep
	= chars:(sp1:spaces? nl:newline sp2:spaces? { return (sp1 ? sp1 : '') + nl + (sp2 ? sp2 : ''); } )+
		{ return chars.join(''); }
	/ chars:spaces
		{ return chars; }
 
tableName			= name:resource spaces? ':'																	{ return name;}

resources
	= head:resource tail:(sep? ',' sep? resource)*
	{
		return [head].concat(tail.map(res => res[3]));
	}

resource			= name:(
						lib:'lib://' res:[^ \t\r\n()]+		{ return { value: lib + res.join(''), 					txt: () => computeText(arguments) }; }
						/ name:('@'? alphanum)				{ return { value: (name[0] ? name[0] : '') + name[1], 	txt: () => computeText(arguments) }; }
						/ name:braceQuoteString				
						/ name:doubleQuoteString
						/ name:singleQuoteString
						/ name:diagonalQuoteString
					)
					{ return name;}
					
variableName		= name:alphanum
variableValue 		= expression
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