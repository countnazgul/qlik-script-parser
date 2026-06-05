// DROP block

dropBlock = dropFieldBlock / dropTableBlock

dropFieldBlock "Drop field(s)"
	= d:'DROP'i s1:sep type:('FIELD'i) s:('S'i)? s2:sep fields:resources s3:sep? f:(from:'FROM'i s4:sep fromTable:resources)? ';'
	{
		return {
			type: type,
			fields: fields,
            table: f ? f.fromTable : undefined,
			// from: from ? from.res : false,
			txt: () => computeText(arguments)
		}
	}

dropTableBlock "Drop table(s)"
	= d:'DROP'i s1:sep type:('TABLE'i) s:('S'i)? s2:sep tables:resources s3:sep? ';'
	{
		return {
			type: type,
			tables: tables,
			// from: from ? from.res : false,
			txt: () => computeText(arguments)
		}
	}
