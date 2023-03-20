import { readFileSync } from "fs";
import { parse } from "../dist/qlik-script-parser.js";

const scriptFile = "./script_files/script1.qvs";
const script = readFileSync(scriptFile).toString();

const parsedText = parse(script);
let a = 1;
