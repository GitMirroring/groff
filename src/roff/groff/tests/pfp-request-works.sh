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
.pfp
.fp 50 EURO
.pfp 50
.'

error=$(printf '%s\n' "$input" | "$groff" -T ps 2>&1)
echo "$error"

echo 'checking list of mounting position populated by default' >&2
echo "$error" \
    | grep -Fqx '5	TR	TR	Times-Roman' || wail # embedded tabs

echo 'checking mounting position configured by input' >&2
echo "$error" \
    | grep -Fqx '50	EURO	EURO	FreeEuro' || wail # embedded tabs

test -z "$fail"

# vim:set autoindent expandtab shiftwidth=4 tabstop=4 textwidth=72:
