// BINARY block

binaryBlock	"Binary"
            = 'BINARY'i spaces bin:resource spaces? ';'
            {
                return {
	                type: "BINARY",
                    path: bin
                }
            }
