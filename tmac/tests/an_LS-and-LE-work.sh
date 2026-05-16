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
.TH foo 1 2026-05-10 "groff test suite"
.SH Name
foo \- frobnicate a bar
.SH Description
.LS itemized 1 4n
.IP \(bu
alpha
.IP \(bu
beta
.IP \(bu
gamma
.RS 10n
.LS definition 0 12n
.TP
.B charlie
Sed ut perspiciatis.
.TP
.B delta
Unde omnis iste natus error sit voluptatem.
.IP
Totam rem aperiam eaque ipsa,
quae ab illo inventore veritatis
et quasi architecto beatae vitae dicta sunt.
.TP
.B echo
Accusantium doloremque laudantium.
.LE
.RE
.P
.IP \(bu
delta
.LE
.SS "Assembly language"
Several computer architectures satisfy Turing-completeness
with a single instruction.
.P
.LS itemized 1
.IP 1.
the PDP-8:
.B ISZ
.IP 2.
the PDP-11:
.B SOB
.IP 3.
the Z80:
.B DJNZ
.IP 4.
the 8086:
.B LOOPZ
.LE
.LS definition 0 5n \" maybe a poor fit for HP, but oh well
.HP
Let\[cq]s hang,
bro.
Ut enim ad minima veniam,
quis nostrum exercitationem ullam corporis suscipitlaboriosam,
nisi ut aliquid ex ea commodi consequatur?
.HP 10n
I can hang longer than you.
Quis autem vel eum iure reprehenderit,
qui inea voluptate velit esse,
quam nihil molestiae consequatur,
vel illum,
qui dolorem eum fugiat,
quo voluptas nulla pariatur?
.LE
.'

output=$(printf "%s\n" "$input" \
    | "$groff" -rDEBUG=1 -r LL=65n -m an -T ascii -P -cbou \
    | nl -ba | tr '\t' ' ')

echo "$output"

# Expected output:
#      1  foo(1)               General Commands Manual               foo(1)
#      2
#      3  Name
#      4       foo - frobnicate a bar
#      5
#      6  Description
#      7       *   alpha
#      8       *   beta
#      9       *   gamma
#     10
#     11                 charlie     Sed ut perspiciatis.
#     12
#     13                 delta       Unde omnis iste natus error sit volup-
#     14                             tatem.
#     15
#     16                             Totam  rem aperiam eaque ipsa, quae ab
#     17                             illo inventore veritatis et quasi  ar-
#     18                             chitecto beatae vitae dicta sunt.
#     19
#     20                 echo        Accusantium doloremque laudantium.
#     21
#     22       *   delta
#     23
#     24     Assembly language
#     25       Several  computer  architectures satisfy Turing-completeness
#     26       with a single instruction.
#     27
#     28       1.     the PDP-8: ISZ
#     29       2.     the PDP-11: SOB
#     30       3.     the Z80: DJNZ
#     31       4.     the 8086: LOOPZ
#     32
#     33       Let's hang, bro.  Ut enim ad minima veniam, quis nostrum ex-
#     34            ercitationem ullam corporis suscipitlaboriosam, nisi ut
#     35            aliquid ex ea commodi consequatur?
#     36
#     37       I can hang longer than you.  Quis autem vel eum iure  repre-
#     38                 henderit,  qui inea voluptate velit esse, quam ni-
#     39                 hil molestiae consequatur, vel illum, qui  dolorem
#     40                 eum fugiat, quo voluptas nulla pariatur?
#     41
#     42  groff test suite            2026-05-10                     foo(1)

echo "checking that list compactness is applied" >&2
echo "$output" | grep -Eqx '[[:space:]]+8[[:space:]]+\* +beta' || wail
echo "checking that nested list indentation accumulates" >&2
echo "$output" \
    | grep -Eq '^[[:space:]]+11[[:space:]]{16}charlie {5}Sed' \
    || wail
echo "checking that compactness not applied to continuation pararaphs" \
    >&2
echo "$output" | grep -Eq '[[:space:]]+16[[:space:]]+Totam' || wail
echo "checking that hanging paragraph employs indentation of" \
    "containing list" >&2
echo "$output" | grep -Eq '[[:space:]]+34[[:space:]]{11}ercitationem' \
    || wail
echo "checking that identation argument to hanging paragraph macro" \
    "overrides list indentation" >&2
echo "$output" | grep -Eq '[[:space:]]+38[[:space:]]{16}henderit' \
    || wail

test -z "$fail"

# vim:set autoindent expandtab shiftwidth=4 tabstop=4 textwidth=72:
