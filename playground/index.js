const fs = require('fs')
const parser = require('../dist/qlik-script-parser')

let scriptFile = './script_files/script1.qvs'
let script = fs.readFileSync(scriptFile).toString()

let parsedText = parser.parse(script)
// breakpoint next row
let a = 1
