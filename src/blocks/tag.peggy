// TAG

tagBlock
	= t:'TAG'i sep1:sep f:('FIELD'i sep)? res:resource sep2:sep w:'WITH'i sep3:sep tag:(string / $ ('$' resource))
	{ return { mode: 'SINGLE', resource: res, tag: tag, txt: () => computeText(arguments) } }
	/ t:'TAG'i sep1:sep f:'FIELDS'i sep2:sep res:resources sep3:sep u:'USING'i sep4:sep map:resource
	{ return { mode: 'MAP', resources: res, map: map, txt: () => computeText(arguments) } }

