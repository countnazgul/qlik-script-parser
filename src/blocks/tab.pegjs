// TAB - ///$tab Main\r\n

tabBlock
	= '///$tab ' t:(char:anyString { return char })+
       { 
            return { 
              name: t.join(''), 
              location:location(), 
              txt: () => computeText(arguments) 
            } 
        }