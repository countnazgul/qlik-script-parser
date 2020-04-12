## First of all I want to thank to [Loïc Formont](https://github.com/pouc) for his [Qlik Script Log Parser](https://github.com/pouc/qlik-script-log-parser)! Amazing work!

# PEG.js parser for Qlik script

**WIP**. Most likely will be in this state for a long time

The idea behind this is to create JS parser that can parse Qlik script files/strings and produce a list of the script elements, using [PEG.js](https://pegjs.org/)

The produced parser can be used as a base for building additional tools. Like:

- offline check the script for syntax errors - no need to open connection to the engine upload the script to an app and ask the engine to check for errors
- highlighters - build highlighter for text editors (such as [CodeMirror](https://codemirror.net/))
- Qlik script formatter - the provided Qlik script can be formatted. Unify the look of Qlik scripts

**Roadmap** (in order asc -> desc)

- change Loïc's script to "fit" the script files syntax (and not only the script logs)
- fix few issues that have spotted
- extend the script to include all the functionality (some are marked as TODO in the original script)

**Future:**

Once the script parser is complete the next step is to create similar parser but for Qlik expressions (only thinking about describing the set analysis is giving me a headache)

I do have a set of scripts to test with but feel free to submit/mail extra scripts.

PS. Have a look at the `docs/index.html` at the "beauty" of the rules
