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


