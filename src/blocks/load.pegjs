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
	
	

