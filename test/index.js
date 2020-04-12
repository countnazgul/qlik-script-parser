const fs = require('fs')
const Tracer = require('pegjs-backtrace')

const parser = require('../dist/qlik-script-parser')
// const parser = require('../dist/qlik-script-parser-original')

let scriptFile = './script_files/script1.txt'

let script = fs.readFileSync(scriptFile).toString()

var tracer = new Tracer(script, {
  showTrace: true,
  showFullPath: true,
})

// try {
let parsedText = parser.parse(script, { tracer: tracer })
// fs.writeFileSync('../tree-viz/tree.json', JSON.stringify(parsedText, null, 4))
let a = 1
// } catch (e) {
//   console.log(tracer.getBacktraceString())
// }

// let t = parser.parse(script)
