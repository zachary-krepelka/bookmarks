#!/usr/bin/sed -nf

# FILENAME: doc.sed
# AUTHOR: Zachary Krepelka
# DATE: Tuesday, February 18th, 2025
# ABOUT: inline pod extractor / documentation tool
# ORIGIN: https://github.com/zachary-krepelka/bookmarks.git
# UPDATED: Sunday, June 1st, 2025 at 11:52 PM

/^# =pod/,/^# =cut/{
	s/^# \?//
	p
}

# A lot of documentation for a little bit of code.
# Maybe a bit excessive, but documentation is important!

# =pod
#
# =head1 NAME
#
# doc.sed - inline pod extractor
#
# =head1 SYNOPSIS
#
#  sed -nf doc.sed [FILE] | pod2text | less
#  sed -nf doc.sed [FILE] | pod2html | lynx -stdin
#  sed -nf doc.sed [FILE] | podchecker
#
# =head2 Documentation
#
# Invoke this script on itself.
#
# =head1 DESCRIPTION
#
# The purpose of this script is to extract pod (a markup language) from
# consecutive, single-line, source-code comments.  My motive for this is to
# embed inline pod documentation in scripts written in languages which do not
# support prologue comment blocks.  This script is compatible with languages
# that use the hash as a single-line comment delimiter, but this is easy to
# change.
#
# =head2 Background
#
# The Perl programming language is the progenitor of the pod markup language;
# Perl supports pod natively, and the two can be intermixed.  This has the
# benefit of keeping code and documentation tightly coupled, as they can exist
# together within the same file.
#
# We can also use pod in contexts outside of Perl.  Particularly, pod can be
# embedded inside of block quotes, allowing scripts written in languages other
# than Perl to be documented using pod within the same source file.  A pod
# interpreter like C<perldoc> can then be invoked directly on the file.  For
# example, I could document an AutoHotkey script using pod, and that
# documentation would be accessible by typing C<perldoc myscript.ahk>.
#
# =head2 Problem
#
# However, it is more difficult to embed pod in languages that do not support
# block comments like C<sed> and C<jq>.  Pod has to be commented out using
# inline comments, which must then be extracted.  This script performs that job.
#
# =head1 EXAMPLE
#
# To document a sed script using POD, one would normally have to wrap it in a
# shell script, like this. (One benefit is that you can also add a --help flag).
#
#	01  #!/usr/bin/env bash
#	02
#	03  sed -f - <<-EOF $1
#	04
#	05  s/foo/bar/
#	06  s/baz/quuz/
#	07
#	08  EOF
#	09
#	10  : <<='cut'
#	11  =pod
#	12
#	13  =head1 NAME
#	14
#	15  sed-script.sh - a shell wrapper around a sed script.
#	16
#	17  =head1 SYNOPSIS
#	18
#	19  bash sed-script.sh [input file] > [output file]
#	20
#	21  =head1 DESCRIPTION
#	22
#	23  This is a demonstration of how to document a sed script.
#	24
#	25  =cut
#
# But this is a sed script, not a shell script, so it is preferable to keep the
# C<.sed> file extension.  Let's not introduce a dependency just to write
# documentation.  Instead, let's do something like this.
#
#	01 #!/usr/bin/env sed
#	02
#	03 s/foo/bar/
#	04 s/baz/quuz/
#	05
#	06 # =pod
#	07 #
#	08 # =head1 NAME
#	09 #
#	01 # script.sed - a sed script
#	11 #
#	12 # =head1 SYNOPSIS
#	13 #
#	14 # sed -f script.sed [input file] > [output file]
#	15 #
#	16 # =head1 DESCRIPTION
#	17 #
#	18 # This is a demonstration of how to document a sed script.
#	19 #
#	20 # =cut
#
# But now C<perldoc FILE> does not work, so we have to extract the pod
# ourselves.  That's what this script does.
#
# =head1 SEE ALSO
#
# =over
#
# =item L<https://www.oreilly.com/library/view/bash-cookbook/0596526784/ch05s02.html>
#
# =item L<http://bahut.alma.ch/2007/08/embedding-documentation-in-shell-script_16.html>
#
# =item L<https://charlotte-ngs.github.io/2015/01/BashScriptPOD.html>
#
# =back
#
# =head1 AUTHOR
#
# Zachary Krepelka L<https://github.com/zachary-krepelka>
#
# =cut
