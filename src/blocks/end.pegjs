// END block

endBlock 						= 'END'i spaces? end:( 'IF'i / 'SUB'i ) { return false; }