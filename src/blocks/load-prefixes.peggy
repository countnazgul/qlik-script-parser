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

	
