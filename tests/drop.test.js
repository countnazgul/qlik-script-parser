const qlikParser = require('../dist/qlik-script-parser')

let dropStatements = `Drop table [My table];
Drop fields [My field];
Drop fields [My field], test;
Drop field [My field];
Drop [My field];
`

test('Drop statement', () => {
  let parserResult = qlikParser.parse(dropStatements)
  //   expect(parserResult.blocks.length).toBe(3)
  expect(parserResult.blocks[0].blockType).toBe('DROP')
  expect(parserResult.blocks[1].blockType).toBe('DROP')
  expect(parserResult.blocks[2].blockType).toBe('DROP')
  expect(parserResult.blocks[3].blockType).toBe('DROP')
  expect(parserResult.blocks[4].blockType).toBe('UNKNOWN')
})
