# sirolf2009 eclipse tools

## TODO

### move selection left/right
alt+up moves the current line up, so alt+left should move the text that you have selected left. If you haven't got anything selected, move the word that you're at.

### param edit
An editing mode where stuff like ctrl+left wont select the word to the left, but select the entire parameter that your caret is at. Also stuff like ctrl+delete would delete the entire parameter. Shift+end should select all params to the right, not until the end of the line. Can be used in function declaration but also function calls

### function edit?
Same as param edit, but then the shortcuts are bound to functions... or something? kinda like emacs minor modes. If we're going down that road we should probably add statement mode as well. Maybe stream mode? 

### code folding on headers
Support text headers and allow code to be folded. maybe also support header hierarchy, as in a code section can be in another code section. These should appear in outline