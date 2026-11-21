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

grotty="${abs_top_builddir:-.}/grotty"

input='#
x T ascii
x res 240 24 40
x init
p1
x font 1 R
f1
s10
V40
H0
md
DFd
tA
v16000
tB
n40 0
x trailer
V2640
x stop
#'

output=$(printf '%s\n' "$input" | "$grotty" -F font -F build/font \
    | sed '/^$/d')
echo "$output"
echo "$output" | grep -q 'B'

# vim:set autoindent expandtab shiftwidth=4 tabstop=4 textwidth=72:
