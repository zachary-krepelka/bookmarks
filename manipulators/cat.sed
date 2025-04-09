#!/usr/bin/env sed -nf

# FILENAME: cat.sed
# AUTHOR: Zachary Krepelka
# DATE: Tuesday, April 8th, 2025
# ABOUT: concatenate Netscape bookmark files
# ORIGIN: https://github.com/zachary-krepelka/bookmarks.git

1,/^<D/p            # print the very beginning of the first file
$p                  # print the very end of the last file
/^<D/,/^<\/D/{      # ignore fluff, focus on content
        /^<\/\?D/d  # remove the boundary between files
        p           # print relevant content
}

# =pod
#
# =head1 NAME
#
# cat.sed - concatenate Netscape bookmark files
#
# =head1 SYNOPSIS
#
#  sed -nf cat.sed [BOOKMARK FILES]
#
# =head2 Documentation
#
#  sed -n '/^# =pod/,/^# =cut/{s/^# \?//;p}' cat.sed | pod2text | less
#  sed -n '/^# =pod/,/^# =cut/{s/^# \?//;p}' cat.sed | pod2html | lynx -stdin
#
# =head1 DESCRIPTION
#
# Concatenate Netscape bookmark files to standard output.  Unlike the Unix cat
# utility, we do not literally concatenate the files as they are.  Instead, we
# concatenate them with respect to their internal file structures so that the
# top level bookmarks and folders in each bookmark file are sequentially
# accumulated into a single bookmark file.  Top-level bookmarks and folders
# appear sequentially in the output file according to the order that the input
# files were supplied on the command line.
#
# =head2 Input
#
# The input consists of one or more files in the Netscape bookmark file format.
# These can be exported from web browsers.  Input files are not modified.  Input
# validation is not performed, so be sure you are using the correct format.
#
# =head2 Output
#
# The output is a file in the Netscape bookmark file format written to standard
# output.  This can be imported into a web browser.
#
# =head1 EXAMPLE
#
# Consider a bookmark file called C<canada.html>
# with the following file structure.
#
# 	Canada/
# 	|-- British Columbia/
# 	|   |-- Vancouver
# 	|   `-- Victoria
# 	`-- Ontario/
# 	    |-- Ottawa
# 	    `-- Toronto
#
# Also consider a bookmark file called C<usa.html>.
#
# 	USA/
# 	|-- Illinois/
# 	|   |-- Chicago
# 	|   `-- Urbana
# 	`-- New York/
# 	    |-- Buffalo
# 	    `-- New York
#
# We can concatenate these files together like so.
#
# 	sed -nf cat.sed canada.html usa.html > northern-america.html
#
# When imported into a web browser, C<northern-america.html>
# will give the following file structure.
#
# 	Imported/
# 	|-- Canada/
# 	|   |-- British Columbia/
# 	|   |   |-- Vancouver
# 	|   |   `-- Victoria
# 	|   `-- Ontario/
# 	|       |-- Ottawa
# 	|       `-- Toronto
# 	`-- USA/
# 	    |-- Illinois/
# 	    |   |-- Chicago
# 	    |   `-- Urbana
# 	    `-- New York/
# 	        |-- Buffalo
# 	        `-- New York
#
# If the files had been supplied to the script in the opposite order, then the
# "USA" folder would have come before the "Canada" folder.
#
# 	sed -nf cat.sed usa.html canada.html > northern-america.html
#
# =head1 SEE ALSO
#
# This script is part of my GitHub repository.
#
# 	https://github.com/zachary-krepelka/bookmarks.git
#
# This repository contains various scripts for bookmark management.
#
# =head1 AUTHOR
#
# Zachary Krepelka L<https://github.com/zachary-krepelka>
#
# =cut

# BONUS: Originally written in Perl, I found it more succinct to
# rewrite this script in sed, but the same thought process can
# be observed in both implementations.  The original script is
# shown below.
#
#	 1 #!/usr/bin/env perl
#	 2
#	 3 # FILENAME: concat.pl
#	 4 # AUTHOR: Zachary Krepelka
#	 5 # DATE: Monday, January 20th, 2025
#	 6
#	 7 use strict;
#	 8 use warnings;
#	 9 use feature qw(say);
#	10
#	11 while (defined(my $outer = <>)) {
#	12
#	13 	chomp $outer;
#	14
#	15 	if ($outer eq "    </DL><p>") {
#	16
#	17 		while (defined(my $inner = <>)) {
#	18
#	19 			if ($inner =~ /bar/) {
#	20
#	21 				scalar <>;
#	22 				last;
#	23
#	24 			} # if
#	25
#	26 		}  # while
#	27
#	28 		last if eof;
#	29
#	30 	} else { say $outer; }
#	31
#	32 } # while
#	33
#	34 print <<'END';
#	35     </DL><p>
#	36 </DL><p>
#	37 END
