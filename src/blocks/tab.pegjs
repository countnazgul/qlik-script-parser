// TAB - ///$tab Main\r\n

tabBlock
	= '///$tab' sp:sep? res:resources
      { return { name: res, txt: () => computeText(arguments) } }