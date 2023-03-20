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

