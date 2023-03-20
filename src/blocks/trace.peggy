// TRACE block. Single & multiple rows are handled
traceBlock = "TRACE"i (spaces / newline) inner:(!";" i:. {return i})*  ';'
				{ 
					return { 
						trace: inner.join(''), 
						txt: () => computeText(arguments) 
					}
				}

