#!/bin/bash

cat <<MARK
LEGEND

C- Control + next char
M- Meta + next char
, separates 2 potential commands
ESC x Gets treated as M-x


MOVEMENT

C-a: Move to end of line
C-e: Move to beginning of line
C-f: Move forward one char
C-b: Move backward one char
M-f: Move forward to the end of the next word
M-b: Move back to the start of the current or previous word

C-l: Clear screen


HISTORY

C-p: Fetch previous command from history
C-n: Fetch next command from history
M-<: Move to the first line in the history
M->: Move to the end of the input history (line currently being entered)
C-r: Search backward start through history (incremental)
C-s: Search forward through history (from current line) (incremental)
M-p: Search backward through history (non-incremental)
M-n: Search forward through history (non-incremental)
M-C-y [n]: Insert the nth argument from the previous command (default to first)
M-., M-_: Insert the last argument from the previous command

M-C-e: Do shell expansion on current line
M-^: Perform history expansion on the current line

C-o Accept current line for execution and fetch next line relative from history for editing (good if you're repeating multiple commands)
C-xC-e Invoke an editor on the current line, execute result


TEXT MANIPULATION

C-d: Delete current char
C-q, C-v: Insert next character typed to the line (can enter control chars)
C-v TAB: Insert tab char
C-t: Transpose letter - push current character backward
M-t: Transpose word
M-u: Uppercase the current or following word
M-l: Lowercase the current or following word
M-c: Capitalize the current or following word


KILL/YANK TEXT

C-k: kill text to the end of line
C-x backspace: kill text to beginning of line
M-d: Kill to end of word
M-backspace: Kill previous word (backward-word boundary)
C-w: Kill previous word (white space boundary)
M-\\: Delete whitespace around cursor
C-y: Yank the top of the kill ring into the buffer at point
M-y: Rotate the kill ring and yank the new top


COMPLETING

TAB: Perform completion
M-?: List possible completions
M-*: Insert all possible completions
M-/: Complete filename
C-x /: List possible completions treating as a filename
M-~: Complete username
C-x ~: List all possible usernames
M-$: Complete variable
C-x $: List possible completions treating as a variable
M-@: Attempt completion treating as a hostname
C-x @: List possible competions treating as a hostname
M-!: Complete as command
C-x !: List possible completions treating as a command
M-TAB: Attempt completion from history
M-{: Filename completion wrapped in braces


KEYBOARD MACROS
C-x (: Start recording macro
C-x ): Stop recording macro
C-x e: Execute last macro


MISC

C-x C-r: Reread inputrc file
C-g: Abort command
M-a,M-b,...: If letter is lower case, do uppercase command
ESC [x]: Metafy next character (ESC f => M-f)
C-_, C-x C-u: Incremental undo remembered separately for each line
M-r: revert line
M-&: Perform tilde expansion
C-@, M<space>: Set mark to point
C-x C-x: Swap point with mark (change cursor position to mark or back)
C-]: Move to next occurance of following letter typed
M-C-]: Move to previous occurance of the following letter typed
M-#: Value of the readline comment-begin variable is inserted at the beginning of line
M-g: Expand as path
C-x *: List possible path expansions

MARK 
