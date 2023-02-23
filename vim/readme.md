# Vim

Notes from vim tutor.

## Modes
v - visual selection mode
V - full line visual selection mode
i - insert mode
a - insert mode on next char
A - insert mode on line end
o - add line below and insert mode
O - add line above and insert mode
x - remove one char
r<char> - replace a char
R - replace multiple chars (like insert key)

## Motions
h,j,k,l - left, down, up, right
gg - file start
G - file end
<num>G - line <num>
w - next word beginning
e - next word ending
b - previous word beginning
0 - line beginning
$ - line ending
<num><motion> - repeat motion n times
ctrl-g - show current line number (and file status)

## Jump to next/prev location
ctrl-o - jump to previous location
ctrl-i - jump to next location

## Undo/redo
u - undo last change
U - undo all changes in the given line
ctrl-r - redo

## Operators
d<motion> - delete text according to the motion
dd - deletes whole line
c<motion> - (change) delete text according to the motion and enter insert mode
cc - changes whole line
p - paste deleted text


Examples:
dw - delete text to the end of the word
d$ - delete text to the end of the line
d2w - delete two words
dd - delete a line
2dd - delete two lines

## Search
/<text> - search <text>
n - next
N - previous
?<text> - search in reverse order

## Replace
:<area>s/<pattern>/<replacement>/<flags> - replace pattern with replacement in a area with flags

Most common:
:%s/ABC/abc - replaces "ABC" with "abc" in the line
:%s/ABC/abc/g - replaces all "ABC" with "abc" whole file
:%s/ABC/abc/gcI - replacement with confirmation and case sensitivity
:%s/x\(.\)x/y\1y - replace with match groups

## copy-paste
v - enter visual mode
V - enter full line visual mode
y - copy text
p - paste

...with out visual selection:
y<motion> - copy text according to motion
yy - copy full line

## Code
% - go to matching (), [], {}

## Commands
:w - write file
:wq - write and exit
:w <filename> - write current buffer or selection as new file
:r <filename/command> - read file or command and paste
:!ls - execute command
:r !ls - paste result of ls to buffer
