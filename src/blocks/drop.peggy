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

