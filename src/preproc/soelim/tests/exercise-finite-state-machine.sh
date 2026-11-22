#!/bin/sh
#
# Copyright 2026 G. Branden Robinson
#
# This file is part of groff, the GNU roff typesetting system.
#
# groff is free software; you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free
# Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# groff is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
# for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.

soelim="${abs_top_builddir:-.}/soelim"

fail=

wail () {
  echo "...FAILED" >&2
  fail=yes
}

# Exercise unusual states in soelim's FSM.
input='.
.s
.so
.l
.lf
.'

output=$(echo "$input" | "$soelim")
echo "$output"
echo "checking that partial requests are passed through" >&2
echo "$output" | tr '\n' ' ' | grep -Fq '.lf 1 "- . .s .so .l .lf .' \
    || wail

# Check these same cases when they immediately precede EOF.  In the
# absence of the `-r` option, GNU soelim appends the terminal newline
# missing from the input stream.

for token in .s .so .l .lf
do
    echo "checking that token '"$token"' before EOF passes through" >&2
    output=$(printf "%s" $token | "$soelim")
    echo "$output" | grep -Fq "$token" || wail
done

test -z "$fail"

# vim:set autoindent expandtab shiftwidth=4 tabstop=4 textwidth=72:
