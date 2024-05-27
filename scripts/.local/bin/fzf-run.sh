#!/bin/sh

# Script to use fzf as a launcher like dmenu.
#
# Steps:
#
# 1. get all directories from $PATH;
# 2. filter out non-existing directories;
# 3. search for executable files in these directories with fd-find;
# 4. run fzf for sorted list of files, bind Tab to complete query string;
# 5. get last line of output, it is either query string (if no matches
#    found) or current match;
# 6. run program.
#
# One can use this script to launch programs from tmux popup:
#
#   tmux display-popup -w 80% -h 80% -E fzf-run.sh
#
# Notes:
#
# 1. It is much faster to get basename with xargs than with "-x" key
#    of fd-find.
# 2. For tmux popup it is crucial to add "-i" flag to shell command, or
#    background task would be closed before running anything.


echo "$PATH"                                               \
| tr -d  '\n'                                              \
| tr ':' '\0'                                              \
| xargs -0 -I{} sh -c 'test -d "{}" && printf "%s\0" "{}"' \
| xargs -0 -I{} fd -0 --exact-depth 1 -t x -L . "{}"       \
| xargs -0 basename -a                                     \
| sort -u                                                  \
| fzf --print-query --bind="tab:transform-query(echo {1})" \
| tail -n 1                                                \
| xargs -I{} sh -ci "exec {} 1> /dev/null 2> /dev/null &"
