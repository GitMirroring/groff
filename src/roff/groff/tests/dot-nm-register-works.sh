#!/bin/sh
#
# Copyright 2021 G. Branden Robinson
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

groff="${abs_top_builddir:-.}/test-groff"

# Unit-test `.nm` register.

input='.
.nf
foo (\n[.nm])
.nm 1
bar (\n[.nm])
.nn
baz (\n[.nm])
.nm
qux (\n[.nm])
.fi
.'

output=$(printf '%s\n' "$input" | "$groff" -T utf8)
echo "$output"

echo "$output" | grep -Fqx 'foo (0)' || fail=yes
echo "$output" | grep -Fqx '  1 bar (1)' || fail=yes
echo "$output" | grep -Fqx 'baz (1)' || fail=yes
echo "$output" | grep -Fqx 'qux (0)' || fail=yes

test -z "$fail"

# vim:set autoindent expandtab shiftwidth=4 tabstop=4 textwidth=72:
