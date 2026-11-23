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
#

groff="${abs_top_builddir:-.}/test-groff"

fail=

wail () {
    echo "...FAILED" >&2
    fail=yes
}

tmpfile1=savannah-68952a.txt
tmpfile2=savannah-68952b.txt

cleanup () {
    rm -f $tmpfile1 $tmpfile2
}

# A process handling a fatal signal should:
#   1.  Mask all fatal signals of interest.  (GBR often excludes ABRT.)
#   2.  Perform cleanup operations.
#   3.  Unmask the signal (removing the handler).
#   4.  Signal its own process group with the signal caught so that the
#       the children exit and shell accurately reports how the process
#       died.
fatals="HUP INT QUIT TERM"
for s in $fatals
do
    trap "trap '' $fatals; cleanup; trap - $fatals; kill -$s -$$" $s
done

input='.
.tmc START:
.pstream
.open stream1 '$tmpfile1'
.open stream2 '$tmpfile2'
.tmc MIDDLE:
.pstream stream2
.close stream1
.close stream2
.tmc END:
.pstream
.'

output=$(printf '%s\n' "$input" | "$groff" -U)
echo "$output"

# Expected output:
#   START:[ ]
#   MIDDLE:[{"stream": "stream2", "file name": "savannah-68952b.txt", "mode": "writing"}]
#   END:[ ]

echo "checking that no streams are open initially" >&2
echo "$output" | grep -Fqx 'START:[ ]'

echo "checking that argumentful form of 'pstream' request works" >&2
echo "$output" | grep -Eqx 'MIDDLE:\[{"stream": "stream2", [^]]\+}]'

echo "checking that no streams are open finally" >&2
echo "$output" | grep -Fqx 'END:[ ]'

cleanup
test -z "$fail"

# vim:set autoindent expandtab shiftwidth=4 tabstop=4 textwidth=72:
