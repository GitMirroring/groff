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

# Locate directory containing our test artifacts.
artifacts_dir=

for buildroot in . .. ../..
do
    d=$buildroot/src/preproc/soelim/tests/artifacts
    if [ -d "$d" ]
    then
        artifacts_dir=$d
        break
    fi
done

# If we can't find it, we can't test.
if [ -z "$artifacts_dir" ]
then
    echo "cannot find test artifact directory; skipping" >&2
    exit 77 # skip
fi

output=$(echo "$input" \
    | "$soelim" -t -I "$artifacts_dir" "$artifacts_dir"/sorcerer | nl)

# Expected output:
#     1  % file ./../src/preproc/soelim/tests/artifacts/sorcerer, line 1
#     2  % file ../src/preproc/soelim/tests/artifacts/included, line 1
#     3  This file deliberately lacks a trailing newline.
#     4  included
#     5  % file ./../src/preproc/soelim/tests/artifacts/sorcerer, line 2
#     6  stuff
echo "$output"

echo "checking that soelim's '-t' option works (1/3)"
echo "$output" \
    | grep -qx ' *1.*% file .*artifacts/sorcerer, line 1' || wail

echo "checking that soelim's '-t' option works (2/3)"
echo "$output" \
    | grep -qx ' *2.*% file .*/artifacts/included, line 1' || wail

echo "checking that soelim's '-t' option works (3/3)"
echo "$output" \
    | grep -qx ' *5.*% file .*artifacts/sorcerer, line 2' || wail

test -z "$fail"

# vim:set autoindent expandtab shiftwidth=4 tabstop=4 textwidth=72:
