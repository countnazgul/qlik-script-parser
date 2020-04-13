// TAB - ///$tab Main\r\n

tabBlock
	= '///$tab' sep t:(sp:sep? char:anyString { return char })+
      { return { name: t.join(''), txt: () => computeText(arguments) } }