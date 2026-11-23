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

groff="${abs_top_builddir:-.}/test-groff"

fail=

wail () {
  echo ...FAILED >&2
  fail=YES
}

input='.
.pev 0
.ev 1
.ft TI
.pev 1
.ev
.pev
.'

error=$(printf '%s\n' "$input" | "$groff" -T ps 2>&1)
echo "$error"

echo 'checking report of environment 0' >&2
echo "$error" | sed '/environment 1:/,$d' \
    | grep -Fq "resolved font selection: 1 ('TR')" || wail

echo 'checking report of environment 1' >&2
echo "$error" | sed '1,/environment 1:/d' \
    | grep -Eq "resolved font selection: [0-9]+ \('TI'\)" || wail

echo 'checking environment summary report (stacked environments)' >&2
echo "$error" | sed -n '/environment stack:/,/^unstacked/p' \
    | grep -Eqx '[[:space:]]0[[:space:]]\*' || wail

echo 'checking environment summary report (unstacked environments)' >&2
echo "$error" | sed '1,/unstacked environments:/d' \
    | grep -Eqx '[[:space:]]1' || wail

test -z "$fail"

# vim:set autoindent expandtab shiftwidth=4 tabstop=4 textwidth=72:
