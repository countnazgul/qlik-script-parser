// WHEN

whenBlock
	= when:'WHEN'i sp1:spaces cond:expression sp2:spaces statement:blockContent
	{
		
		statement.when = cond;
		statement.txt = () => computeText(arguments);
		return statement;
	}

