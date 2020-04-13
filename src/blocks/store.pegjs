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


