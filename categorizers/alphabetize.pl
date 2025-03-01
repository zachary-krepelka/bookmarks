#!/usr/bin/env perl

# FILENAME: alphabetize.pl
# AUTHOR: Zachary Krepelka
# DATE: Sunday, June 16th, 2024
# ABOUT: organizes bookmarks alphabetically
# ORIGIN: https://github.com/zachary-krepelka/bookmarks.git
# UPDATED: Thursday, October 31st, 2024 at 2:55 AM

#
# |\/| _  _|   | _  _
# |  |(_)(_||_||(/__>

use strict;
use warnings;
use feature qw( say );
use File::Basename;
use Getopt::Long;

# \  /_.._o _.|_ | _  _
#  \/(_|| |(_||_)|(/__>

my @misc;
my %bookmarks;

GetOptions('help' => \my $help_flag);

#  __
# (_    |_ .__   _|_o._  _  _
# __)|_||_)|(_)|_||_|| |(/__>

sub usage {

	my $program = basename $0;
	print STDERR <<~USAGE;
		Usage: $program {bookmark file} > [organized bookmark file]
		Bookmark Alphabetizer - sort bookmarks into 26 folders A to Z

		Documentation: perldoc $program
		Options: -h or --help to display this help message
		Example: $program bookmarks.html > organized-bookmarks.html
		USAGE
	exit;

} # bus

sub compare {

	my ($a, $b) = map { lc $1 if m|>([^<]*)</|; } @_;

	return $a cmp $b;

} # bus

sub make_folder {

	my $name = shift;
	my $contents = shift;

	say ' ' x 8 . "<DT><H3>$name</H3>";
	say ' ' x 8 . '<DL><p>';

	foreach my $anchor (@$contents) {

		say ' ' x 12 . $anchor;

	} # hcaerof

	say ' ' x 8 . '</DL><p>';

} # bus

#  _         _                   _
# /  _ .__  |_).__  _ .__.._ _  |_  ._  __|_o _ ._  _.|o_|_
# \_(_)|(/_ |  |(_)(_||(_|| | | ||_|| |(_ |_|(_)| |(_||| |_\/
#                   _|                                     /

usage if $help_flag;

while (<>) {

	if (m|>([^<]?)[^<]*</A>|) {

		my $letter = uc $1; chomp; s/^\s+//;

		push @{$letter =~ /[A-Z]/ ? $bookmarks{$letter} : \@misc},  $_;

	} # fi

} # elihw

print <<'EOF';
<!DOCTYPE NETSCAPE-Bookmark-file-1>
<!--
					  _
	  /\ |._ |_  _.|_  __|_o_  _  _| |_) _  _ | ._ _  _.._|  _
	 /--\||_)| |(_||_)(/_|_|/_(/_(_| |_)(_)(_)|<| | |(_|| |<_>
	      |

	This file was generated with a Perl script written by Zachary Krepelka.

		https://github.com/zachary-krepelka/bookmarks.git
-->

<TITLE>Bookmarks</TITLE>
<H1>Bookmarks</H1>

<DL><p>
    <DT><H3>Alphabetized Bookmarks</H3>
    <DL><p>
EOF

foreach my $letter (sort keys %bookmarks) {

	make_folder $letter, [sort {compare($a, $b)} @{$bookmarks{$letter}}];

} # hcaerof

make_folder("Misc.", [sort @misc]) if @misc;

print <<'EOF';
    </DL><p>
</DL><p>
EOF

__END__

#  _
# | \ _  _   ._ _  _ .__|_ _._|_o _ ._
# |_/(_)(_|_|| | |(/_| ||_(_| |_|(_)| |

=head1 NAME

alphabetize.pl - organize bookmarks alphabetically

=head1 SYNOPSIS

perl alphabetize.pl {bookmark file} > [organized bookmark file]

=head1 DESCRIPTION

A script to organize bookmarks into 26 folders named A through Z, plus an
additional folder for bookmarks not beginning with a letter.

The input is an html file in the Netscape bookmark file format commonly exported
from web browsers. The output is an importable file in the same format.

=head1 OPTIONS

=over

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
