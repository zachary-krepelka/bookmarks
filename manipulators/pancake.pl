#!/usr/bin/env perl

# FILENAME: pancake.pl
# AUTHOR: Zachary Krepelka
# DATE: Tuesday, June 18th, 2024
# ABOUT: flatten and conjoin nested bookmarks
# ORIGIN: https://github.com/zachary-krepelka/bookmarks.git
# UPDATED: Saturday, April 5th, 2025 at 3:14 AM

#
# |\/| _  _|   | _  _
# |  |(_)(_||_||(/__>

use strict;
use warnings;
use File::Basename;
use Getopt::Long;

#
# \  /_.._o _.|_ | _  _
#  \/(_|| |(_||_)|(/__>

GetOptions(
	'help' => \my $help_flag,
	'root=s' => \my $root_folder_name
);

$root_folder_name = "Pancakes" unless defined $root_folder_name;

#  __
# (_    |_ .__   _|_o._  _  _
# __)|_||_)|(_)|_||_|| |(/__>

sub usage {

	my $program = basename $0;
	print STDERR <<~USAGE;
		Usage: $program [options] {bookmark file(s)}
		Flatten and conjoin nested bookmark files

		Options:
		  -r STR, --root=STR   use STR as name for [r]oot folder
		  -h, --help           print this [h]elp message and exit

		Documentation: perldoc $program
		Example: $program bookmarks.html > flattened-bookmarks.html
		USAGE
	exit;
}

#  _         _
# /  _ .__  |_  ._  __|_o _ ._  _.|o_|_
# \_(_)|(/_ ||_|| |(_ |_|(_)| |(_||| |_\/
#                                      /

usage if $help_flag;

print <<"EOF";
<!DOCTYPE NETSCAPE-Bookmark-file-1>

<!--
	 _                     _
	|_)_.._  _ _.|  _  _| |_) _  _ | ._ _  _.._|  _
	| (_|| |(_(_||<(/_(_| |_)(_)(_)|<| | |(_|| |<_>

	This file was generated with a Perl script written by Zachary Krepelka.

		https://github.com/zachary-krepelka/bookmarks.git
-->

<TITLE>Bookmarks</TITLE>
<H1>Bookmarks</H1>

<DL><p>
    <DT><H3>$root_folder_name</H3>
    <DL><p>
EOF

while (<>) {

	if (/<A/) {

		s/^\s+//;

		print ' ' x 8 . $_;
	}
}

print <<'EOF';
    </DL><p>
</DL><p>
EOF

__END__

#  _
# | \ _  _   ._ _  _ .__|_ _._|_o _ ._
# |_/(_)(_|_|| | |(/_| ||_(_| |_|(_)| |

=head1 NAME

pancake.pl - flatten and conjoin nested bookmark files

=head1 SYNOPSIS

perl pancake.pl [options] {bookmark file(s)} > flattened-bookmark-file

=head1 DESCRIPTION

The purpose of this script is to strip out all the folders from a Netscape
bookmark file, leaving only the bookmarks.  This transforms a nested file
structure into a flat list.

If this script is invoked on multiple input files, the bookmarks in each file
are accumulated together into one output file.  This can be utilized to
concatenate many bookmark files into a single, contiguous bookmark file with no
folders.

The resulting list will be in the order that the bookmarks were encountered
while reading over the input files from beginning to end, which will reflect the
order that the bookmarks were originally in within the folders.

=head2 Input

The input consists of one or more files in the Netscape bookmark file format.
These can be exported from web browsers.  Input files are not modified.

=head2 Output

The output is a file in the Netscape bookmark file format written to standard
output.  This can be imported into a web browser.

=head2 Use Case

It is sometimes helpful to reorganize portions of one's bookmarks into a flat
list.  Folders are useful for structuring data, but they can also lead to
unnecessary and overbearing complexity.  Deeply nested folder structures can
become difficult to effectively navigate and maintain.

=head1 OPTIONS

=over

=item B<-r> I<STR>, B<--root>=I<STR>

Use I<STR> as the name of the root folder containing all of the bookmarks;
otherwise, the name "Pancakes" is used.

=item B<-h>, B<--help>

Display a help message and exit.

=back

=head1 EXAMPLES

 perl pancake.pl -r food recipes-by-mealtime.html > list-of-recipes.html

 +------------------------------+--------------------------+
 |   recipes-by-mealtime.html   |   list-of-recipes.html   |
 +------------------------------+--------------------------+
 |                              |                          |
 |  recipes/                    |  food/                   |
 |  |-- breakfast/              |  |-- blueberry pancakes  |
 |  |   `-- blueberry pancakes  |  |-- strawberry salad    |
 |  |-- lunch/                  |  `-- spaghetti           |
 |  |   `-- strawberry salad    |                          |
 |  `-- dinner/                 |                          |
 |     `-- spaghetti            |                          |
 |                              |                          |
 +------------------------------+--------------------------+

=head1 NOTES

=head2 About the Name

The name of this script is intended as a transitive verb; to pancake something
means to knock it flat, e.g., "the tsunami pancaked the landscape."

=head2 About Concatenation

The primary purpose of this script is to restructure a folder hierarchy into a
flat list.  The ability to concatenate multiple bookmark files is only a
secondary consideration.  Everything is flattened regardless.

If you would like to concatenate bookmark files while maintaining their file
structures, I wrote a dedicated script for this purpose called C<cat.sed>.  It
can be found in my GitHub repository as stated below.

=head1 SEE ALSO

This script is part of my GitHub repository.

	https://github.com/zachary-krepelka/bookmarks.git

This repository contains various scripts for bookmark management.

=head1 AUTHOR

Zachary Krepelka L<https://github.com/zachary-krepelka>

=cut

#
