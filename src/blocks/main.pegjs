// Base script used from https://github.com/pouc/qlik-script-log-parser

{
	function isFunction(functionToCheck) {
		var getType = {};
		return functionToCheck && getType.toString.call(functionToCheck) === '[object Function]';
	}
	
	function sortArgs(args) {
		return Array.prototype.slice.call(args);
	}
	
	function computeTextUnit(arrgs) {
	
		if (typeof arrgs === 'undefined') return '';
		else if (Array.isArray(arrgs)) return arrgs.map(arg => computeTextUnit(arg)).join('');
		else if (arrgs !== null && typeof arrgs === 'object' && arrgs.hasOwnProperty('txt') && isFunction(arrgs.txt)) return arrgs.txt();
		else if (arrgs !== null && typeof arrgs === 'object' && (!arrgs.hasOwnProperty('txt') || isFunction(arrgs.txt))) return '';
		else if (arrgs !== null && typeof arrgs !== 'object') return '' + arrgs;
		else return '';

	}

	function computeText(args) {
		return computeTextUnit(sortArgs(args));
	}
}


QlikLogFile
	= blocks

blocks
	= '\ufeff'? head:block tail:(newline block spaces? )* {
		return {
			blocks: tail.reduce(function(result, element) {
				if(element[1] !== null) return result.concat([element[1]]);
				else return result;
			}, [ head ]),
			txt: () => computeText(arguments)
		}
	}
   
// TODO
// - ALIAS
// - DIRECTORY
// - EXECUTE
// - FLUSHLOG
// - FORCE
// - LOOSEN
// - MAP
// - NULLASNULL
// - NULLASVALUE
// - REM - done
// - SQLCOLUMNS
// - SQLTABLES
// - SQLTYPES
// - UNMAP
// - UNTAG
// - SWITCH 
  
block
	= txt:($ spaces?) & spEndofrow
	{
		return {
			blockType: 'EMPTY',
			txt: () => computeText(arguments)
		};
	}
	
	/ comment:scriptCommentBlock & spEndofrow
	{
		return {
			blockType: 'COMMENT',
			block: comment,
			txt: () => computeText(arguments)
		};
	}
	
	/ connectBlock:connectBlock & spEndofrow
	{
		return {
			blockType: 'CONNECT',
			block: connectBlock,
			txt: () => computeText(arguments)
		};
	}
	
	/ hiddenBlock:hiddenBlock & spEndofrow
	{
		return {
			blockType: 'HIDDEN',
			block: hiddenBlock,
			txt: () => computeText(arguments)
		};
	}
	
	/ traceBlock:traceBlock & spEndofrow
	{
		return {
			blockType: 'TRACE',
			block: traceBlock,
			txt: () => computeText(arguments)
		};
	}
	
	/ block:whenBlock & spEndofrow
	{
		return block;
	}
	
	/ block:blockContent & spEndofrow
	{
		return {
			blockType: block.type,
			block: block.block,
			txt: () => computeText(arguments)
		};
	}
	
	/ unknownBlock:unknownBlock & spEndofrow
	{
		return {
			blockType: 'UNKNOWN',
			unknown: unknownBlock,
			txt: () => computeText(arguments)
		};
	}
	
	
blockContent		=
	block:letSetBlock			{ return { type: 'LET SET',		block: block, txt: () => computeText(arguments) }; }
	/	block:ifBlock			{ return { type: 'IF',			block: block, txt: () => computeText(arguments) }; }
	/	block:elseBlock			{ return { type: 'ELSE',		block: block, txt: () => computeText(arguments) }; }
	/	block:endBlock			{ return { type: 'END',			block: block, txt: () => computeText(arguments) }; }
	/	block:loadBlock			{ return { type: 'LOAD',		block: block, txt: () => computeText(arguments) }; }
	/	block:dropBlock			{ return { type: 'DROP',		block: block, txt: () => computeText(arguments) }; }
	/	block:renameBlock		{ return { type: 'RENAME',		block: block, txt: () => computeText(arguments) }; }
	/	block:doBlock			{ return { type: 'DO',			block: block, txt: () => computeText(arguments) }; }
	/	block:loopUntilBlock	{ return { type: 'LOOP UNTIL',	block: block, txt: () => computeText(arguments) }; }
	/	block:exitBlock			{ return { type: 'EXIT',		block: block, txt: () => computeText(arguments) }; }
	/	block:declareBlock		{ return { type: 'DECLARE',		block: block, txt: () => computeText(arguments) }; }
	/	block:deriveBlock		{ return { type: 'DERIVE',		block: block, txt: () => computeText(arguments) }; }
	/	block:forBlock			{ return { type: 'FOR',			block: block, txt: () => computeText(arguments) }; }
	/	block:nextBlock			{ return { type: 'NEXT',		block: block, txt: () => computeText(arguments) }; }
	/	block:storeBlock		{ return { type: 'STORE',		block: block, txt: () => computeText(arguments) }; }
	/	block:sleepBlock		{ return { type: 'SLEEP',		block: block, txt: () => computeText(arguments) }; }
	/	block:binaryBlock		{ return { type: 'BINARY',		block: block, txt: () => computeText(arguments) }; }
	/	block:searchBlock		{ return { type: 'SEARCH',		block: block, txt: () => computeText(arguments) }; }
	/	block:subBlock			{ return { type: 'SUB',			block: block, txt: () => computeText(arguments) }; }
	/	block:callBlock			{ return { type: 'CALL',		block: block, txt: () => computeText(arguments) }; }
	/	block:starIsBlock		{ return { type: 'STAR IS',		block: block, txt: () => computeText(arguments) }; }
	/	block:sectionBlock		{ return { type: 'SECTION',		block: block, txt: () => computeText(arguments) }; }
	/	block:commentBlock		{ return { type: 'COMMENT',		block: block, txt: () => computeText(arguments) }; }
	/	block:tagBlock			{ return { type: 'TAG',			block: block, txt: () => computeText(arguments) }; }
	/	block:qualifyBlock		{ return { type: 'QUALIFY',		block: block, txt: () => computeText(arguments) }; }
	/	block:directBlock		{ return { type: 'DIRECT',		block: block, txt: () => computeText(arguments) }; }














	

	

	
	







