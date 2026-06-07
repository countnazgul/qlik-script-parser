// DERIVE blocks

deriveBlocks = deriveFieldsBlock / deriveExplicitBlock / deriveImplicitBlock

deriveImplicitBlock	"Derive implicit statement"
= 'DERIVE'i sep 'FIELDS'i sep 'FROM'i sep 'IMPLICIT'i sep 'TAG'i
   sep 'USING'i sep using:resources endOfStatement
            {
                return {
                	type: 'implicit',
                    using
                }
            }

deriveExplicitBlock	"Derive explicit statement"
= 'DERIVE'i sep 'FIELDS'i sep 'FROM'i sep 'EXPLICIT'i sep 'TAGS'i
  sep '(' sep? tags:resources sep? ')' sep 'USING'i sep using:resources endOfStatement
            {
                return {
                	type: 'explicit',
                    tags,
                    using
                }
            }

deriveFieldsBlock	"Derive fields statement"
= 'DERIVE'i sep 'FIELDS'i sep 'FROM'i sep 'FIELDS'i sep fields:resources
  sep 'USING'i sep using:resources endOfStatement
            {
                return {
                	type: 'fields',
                    fields,
                    using
                }
            }