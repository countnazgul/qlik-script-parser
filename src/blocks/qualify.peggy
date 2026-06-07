// QUALIFY

qualifyBlock
	= un:('UN'i)? qua:'QUALIFY'i sep:sep fields:searchBlockFields
	{
		return {
			unQualify: un ? true : false,
			fields : fields,
			txt: () => computeText(arguments)
		}
	}
