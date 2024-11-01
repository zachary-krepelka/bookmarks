#!/usr/bin/env perl

# FILENAME: pancake.pl
# AUTHOR: Zachary Krepelka
# DATE: Tuesday, June 18th, 2024
# ABOUT: flattens nested bookmarks
# ORIGIN: https://github.com/zachary-krepelka/bookmarks.git
# UPDATED: Friday, June 21st, 2024 at 11:55 PM

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
		Usage: $program {bookmark file}
		Flatten nested bookmarks

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

	s/^\s+//;

	print ' ' x 8 . $_ if /<A/;

}

print <<'EOF';
    </DL><p>
</DL><p>
EOF

__END__

=head1 NAME

pancake.pl - flatten nested bookmarks

=head1 SYNOPSIS

perl pancake.pl {bookmark file} > [flattened bookmark file]

=head1 DESCRIPTION

This script operates on the Netscape bookmark file format.  It strips out all
the folders from the file, leaving only the bookmarks.  To use this
script:

=over

=item 1 Export your bookmarks from your web browser.

=item 2 Run this script on that file.

=item 3 The output is an importable bookmark file.

=back

=head1 OPTIONS

=over

=item B<-r> I<STR>, B<--root>=I<STR>

Use I<STR> as the name of the root folder containing all of the bookmarks;
otherwise, the name "Pancakes" is used.

=item B<-h>, B<--help>

Display a help message and exit.

=back

=head1 SEE ALSO

This script is part of my GitHub repository.

	https://github.com/zachary-krepelka/bookmarks.git

This repository contains various scripts for bookmark management.

=head1 AUTHOR

Zachary Krepelka L<https://github.com/zachary-krepelka>

=cut

#
