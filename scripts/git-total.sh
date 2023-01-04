#!/bin/bash

for DIR in "$@"; do
    # Only git dirs interesting
    [ -d "$DIR/.git" ] && cd "$DIR" || continue

    # git branch -v gives ahead/behind info
    # using perl - sorry for this
    MOD=`git branch -v | perl -wlne '/^..(\S+)\s+([a-f0-9]+)\s+(\[ahead\s+(\d+)\])/ or next; print "# Branch ahead: $1"; '`;

    # a series of UGLY HACKs to get pretty-printing
    [ ! -z "$MOD" ] && MOD="
$MOD"
    git status | grep -q '^# Changes' && MOD="$MOD
# Uncommitted changes present"

    # print summary
    [ ! -z "$MOD" ] && echo -e "$DIR:$MOD"
    cd -
done