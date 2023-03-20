import { readFileSync, writeFileSync } from "fs";
import peggy from "peggy";

// List all grammar files. They will be read in the input order
const blocksOrder = [
  "main",
  "unknown",
  "when",
  "hidden",
  "connect",
  "direct",
  "qualify",
  "section-star",
  "sub-call",
  "search",
  "tag",
  "tab",
  "comment",
  "let-set",
  "if",
  "load",
  "load-prefixes",
  "load-fields",
  "load-source",
  "load-suffixes",
  "trace",
  "drop",
  "rename",
  "do",
  "loopUntil",
  "exit",
  "declare",
  "derive",
  "for",
  "next",
  "else",
  "end",
  "store",
  "sleep",
  "binary",
  "expressions",
  "functions",
  "misc",
  "base",
];

const fullGrammar = blocksOrder
  .map((b) => {
    return readFileSync(`./blocks/${b}.peggy`);
  })
  .join("\n\r");

// Once all files are read - write the complete grammar
writeFileSync("../dist/qlik-grammar.peggy", fullGrammar);

// Parse the complete grammar
const parser = peggy.generate(fullGrammar, {
  //   trace: true,
  output: "source",
  format: "es",
});

// Write the parser
writeFileSync("../dist/qlik-script-parser.js", parser);
