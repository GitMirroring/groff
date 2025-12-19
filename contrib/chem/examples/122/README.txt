This directory contains the examples for the chem language written
in the book:

    Computing Science Technical Report No. 122
    CHEM - A Program for Typesetting Chemical Diagrams: User Manual
    by Jon L. Bentley, Lynn W. Jelinski, Brian W. Kernighan

The book is available in the internet at
<http://cm.bell-labs.com/cm/cs/cstr/122.ps.gz>.

Many of the examples had to be fixed.  Unfortunately, the chem akw
version does not run on many of these programs.  But the Perl version
of chem works on all examples.

Most examples do not use the modern chemical display.  They have C
atoms added, whereas the modern method omits all C atoms and their
directly appended H atoms.

The examples are named and sorted by the chapter where they are found
in the book.  For example, the file 'ch4c_colon.chem' means a chem
example in chapter 4; according to 'c', it is the third example in
this chapter; the name 'colon' is used to describe the context of the
example.

You can view the graphical display of the examples by calling

    @g@chem <file> | groff -p ...


##### Editor settings

Local Variables:
mode: text
End:
