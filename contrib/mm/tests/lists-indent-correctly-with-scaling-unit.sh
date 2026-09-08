#!/bin/sh
#
# Copyright 2024-2026 G. Branden Robinson
#
# This file is part of mm, a reimplementation of the Documenter's
# Workbench (DWB) troff memorandum macro package for use with GNU troff.
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

# Regress-test Savannah #68667.
#
# Keep test input in sync with the corresponding portion of
# "lists-indent-correctly.sh", except for explicit indentation arguments
# with scaling unit.  Also, this script tests the groff mm extension
# `BVL` macro.

input='.
.SA 0
.P
This is an
.I mm
document.
Sed ut perspiciatis, unde omnis xxx iste natus error sit voluptatem
accusantium doloremque.
.P 1
This is an indented paragraph.
.AL 1.27c
.LI
a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 a13 a14 a15 a16 a17 a18 a19 a20
a21 a22 a23 a24 a25 a26 a27 a28 a29 a30
.LE
.BL 1.27c
.LI
b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13 b14 b15 b16 b17 b18 b19 b20
b21 b22 b23 b24 b25 b26 b27 b28 b29 b30
.LE
.DL 1.27c
.LI
c1 c2 c3 c4 c5 c6 c7 c8 c9 c10 c11 c12 c13 c14 c15 c16 c17 c18 c19 c20
c21 c22 c23 c24 c25 c26 c27 c28 c29 c30
.LE
.ML ! 1.27c
.LI
d1 d2 d3 d4 d5 d6 d7 d8 d9 d10 d11 d12 d13 d14 d15 d16 d17 d18 d19 d20
d21 d22 d23 d24 d25 d26 d27 d28 d29 d30
.LE
.RL 1.27c
.LI
f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13 f14 f15 f16 f17 f18 f19 f20
f21 f22 f23 f24 f25 f26 f27 f28 f29 f30
.LE
.VL 1.27c
.LI tag
g1 g2 g3 g4 g5 g6 g7 g8 g9 g10 g11 g12 g13 g14 g15 g16 g17 g18 g19 g20
g21 g22 g23 g24 g25 g26 g27 g28 g29 g30
.LE
.BVL 1.27c
.LI "lorem ipsum"
Nemo enim ipsam voluptatem,
quia voluptas sit,
aspernatur aut odit aut fugit.
.'

#
#
#
#                                   - 1 -
#
#
#
#       This is an mm document.  Sed ut perspiciatis, unde omnis xxx
#       iste natus error sit voluptatem accusantium doloremque.
#
#            This is an indented paragraph.
#
#         1. a1 a2 a3 a4 a5 a6 a7 a8 a9 a10 a11 a12 a13 a14 a15 a16
#            a17 a18 a19 a20 a21 a22 a23 a24 a25 a26 a27 a28 a29 a30
#
#          * b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13 b14 b15 b16
#            b17 b18 b19 b20 b21 b22 b23 b24 b25 b26 b27 b28 b29 b30
#
#         -- c1 c2 c3 c4 c5 c6 c7 c8 c9 c10 c11 c12 c13 c14 c15 c16
#            c17 c18 c19 c20 c21 c22 c23 c24 c25 c26 c27 c28 c29 c30
#
#          ! d1 d2 d3 d4 d5 d6 d7 d8 d9 d10 d11 d12 d13 d14 d15 d16
#            d17 d18 d19 d20 d21 d22 d23 d24 d25 d26 d27 d28 d29 d30
#
#          @ e1 e2 e3 e4 e5 e6 e7 e8 e9 e10 e11 e12 e13 e14 e15 e16
#            e17 e18 e19 e20 e21 e22 e23 e24 e25 e26 e27 e28 e29 e30
#
#        [1] f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13 f14 f15 f16
#            f17 f18 f19 f20 f21 f22 f23 f24 f25 f26 f27 f28 f29 f30
#
#       tag  g1 g2 g3 g4 g5 g6 g7 g8 g9 g10 g11 g12 g13 g14 g15 g16
#            g17 g18 g19 g20 g21 g22 g23 g24 g25 g26 g27 g28 g29 g30
#
#       lorem ipsum
#            Nemo enim ipsam voluptatem, quia voluptas sit,
#            aspernatur aut odit aut fugit.

output=$(printf "%s\n" "$input" \
    | "$groff" -mm -Tascii -P-cbou 2> /dev/null)
echo "$output"

echo "checking indentation of AL list, first line" >&2
echo "$output" | grep -Eq "^ {9}1\. a1" || wail

echo "checking indentation of AL list, second line" >&2
echo "$output" | grep -Eq "^ {12}a17" || wail

echo "checking indentation of BL list, first line" >&2
echo "$output" | grep -Eq "^ {10}\* b1" || wail

echo "checking indentation of BL list, second line" >&2
echo "$output" | grep -Eq "^ {12}b17" || wail

echo "checking indentation of DL list, first line" >&2
echo "$output" | grep -Eq "^ {9}-- c1" || wail

echo "checking indentation of DL list, second line" >&2
echo "$output" | grep -Eq "^ {12}c17" || wail

echo "checking indentation of ML list, first line" >&2
echo "$output" | grep -Eq "^ {10}! d1" || wail

echo "checking indentation of ML list, second line" >&2
echo "$output" | grep -Eq "^ {12}d17" || wail

echo "checking indentation of RL list, first line" >&2
echo "$output" | grep -Eq "^ {8}\[1] f1" || wail

echo "checking indentation of RL list, second line" >&2
echo "$output" | grep -Eq "^ {12}f17" || wail

echo "checking indentation of VL list, first line" >&2
echo "$output" | grep -Eq "^ {7}tag {2}g1" || wail

echo "checking indentation of VL list, second line" >&2
echo "$output" | grep -Eq "^ {12}g17" || wail

echo "checking indentation of BVL list, first line" >&2
echo "$output" | grep -Eq "^ {7}lorem ipsum$" || wail

echo "checking indentation of BVL list, second line" >&2
echo "$output" | grep -Eq "^ {12}Nemo enim ipsam voluptatem," || wail

error=$(printf "%s\n" "$input" | "$groff" -z -mm -Tascii -P-cbou 2>&1)
echo "$error"

test -z "$fail"

# vim:set autoindent expandtab shiftwidth=4 tabstop=4 textwidth=72:
