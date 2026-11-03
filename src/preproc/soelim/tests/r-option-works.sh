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

output=$(printf 'a' | "$soelim" -r)

echo "checking that soelim's '-r' option produces no 'lf' requests'" >&2
echo "$output" | grep -Fq '.lf' && wail

output_od=$(printf 'a' | "$soelim" -r | od -c)
printf '%s\n' "$output_od"

echo "checking that soelim's '-r' does not add newline at EOF" >&2
printf '%s\n' "$output_od" | grep -qx '0* *a' || wail

test -z "$fail"

# vim:set autoindent expandtab shiftwidth=4 tabstop=4 textwidth=72:
