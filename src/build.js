const fs = require('fs')
const peg = require('pegjs')

let fullGrammar = ''

// List all grammar files. They will be read in the input order
let blocksOrder = [
  'main',
  'unknown',
  'when',
  'hidden',
  'connect',
  'direct',
  'qualify',
  'section-star',
  'sub-call',
  'search',
  'tag',
  'tab',
  'comment',
  'let-set',
  'if',
  'load',
  'load-prefixes',
  'load-fields',
  'load-source',
  'load-suffixes',
  'trace',
  'drop',
  'rename',
  'do',
  'loopUntil',
  'exit',
  'declare',
  'derive',
  'for',
  'next',
  'else',
  'end',
  'store',
  'sleep',
  'binary',
  'expressions',
  'functions',
  'misc',
  'base',
]

// Read all grammar files and append them to fullGrammar
for (let b of blocksOrder) {
  let block = fs.readFileSync(`./blocks/${b}.pegjs`)
  fullGrammar += '\n\r' + block
}

// Once all files are read - write the complete grammar
fs.writeFileSync('../dist/qlik-grammar.pegjs', fullGrammar)

// Parse the complete grammar
let parser = peg.generate(fullGrammar, {
  //   trace: true,
  output: 'source',
  format: 'commonjs',
})

// Write the parser
fs.writeFileSync('../dist/qlik-script-parser.js', parser)
