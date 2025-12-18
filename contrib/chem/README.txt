chem is a preprocessor for *roff formatters that generates chemical
structure diagrams in the pic language.

The original version of chem is an AWK script written by Brian
Kernighan, formerly sited at <http://cm.bell-labs.com/cm/cs/who/bwk/
ndex.html>.  Historically, the source files of the AWK version of chem
are available at <http://cm.bell-labs.com/netlib/typesetting/chem.gz>.

This project is a rewrite in Perl of the AWK version of chem for groff,
the GNU roff project.  It was written using Perl v5.8.8, but at least
Perl v5.6 is needed to run this Perl version of chem.

In comparison to the original AWK version of chem, this Perl version
makes the following changes.

- Adds options -h, --help, -v, and --version to output usage and version
  information.
- Removes some functions "inline", "shiftfields", and "set", and some
  variables that are used only once.

The subdirectory "examples/" contains example files for chem.  They are
written in the chem language.  The file names end with .chem.


####### License

Copyright (C) 2006-2020 Free Software Foundation, Inc.
Written by Bernd Warken <groff-bernd.warken-72@web.de>.

This file is part of chem.

chem is distributed with groff, the GNU roff typesetting system.

groff is free software; you can redistribute it and/or modify it
under the terms of the GNU General Public License (GPL) version 2 as
published by the Free Software Foundation.

groff is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
for more details.

The GPL2 license text is available in the internet at
<http://www.gnu.org/licenses/gpl-2.0.html>.


##### Editor settings
Local Variables:
fill-column: 72
mode: text
End:
vim: set textwidth=72:
