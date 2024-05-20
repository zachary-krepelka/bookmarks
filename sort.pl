#!/usr/bin/env perl

# FILENAME: sort.pl
# AUTHOR: Zachary Krepelka
# DATE: Sunday, May 19th, 2024
# ABOUT: a command-line bookmark sorter
# ORIGIN: https://github.com/zachary-krepelka/bookmarks.git
# UPDATED: Sunday, May 19th, 2024 at 11:36 PM

use strict;
use warnings;
use File::Basename;
use Getopt::Long;

GetOptions(
	'help'        => \my $help_flag,
	'switch'      => \my $switch_flag,
	'ignore-case' => \my $case_insensitive
);

#  __
# (_    |_ .__   _|_o._  _  _
# __)|_||_)|(_)|_||_|| |(/__>

sub usage {

	my $program = basename $0;
	print STDERR <<~USAGE;
		Usage: $program [bookmark file] > [sorted bookmark file]
		A Recursive, Command-line Bookmark Sorter

		Options:
			-h, --help       	display this help message
			-s, --switch     	sort by URL instead of by name
			-i, --ignore-case	ignore case when sorting

		Documentation: perldoc $program
		Example: sort.pl -i -s bookmarks.html > sorted-bookmarks.html
		USAGE
	exit;
}

my $extract_content = sub {

	# Extracts the content of an html element.

	return $1 if shift =~ m|>([^<]*)</|;

	# https://en.wikipedia.org/wiki/HTML_element#Syntax

};

my $extract_url = sub {

	# Extracts the URL from an html anchor.

	return $1 if shift =~ /HREF="([^"]+)/;

};

sub helper {

	@_ = map lc, @_ if $case_insensitive;

	my $func = $switch_flag ? $extract_url : $extract_content;

	my ($a, $b) = map &$func, @_;

	return $a cmp $b;

}

sub sort_bookmarks {

	print;           # <DT><H3 ...>Folder</H3>
	print scalar <>; # <DL><p>

	my @hrefs = ();

	while (<>) {

		# Ignore bookmarks that are named "Read Me".

		if (/Read Me/) { print; next; }

		push @hrefs, $_ if /<A/; # <DT><A HREF="..." ...>Bookmark</A>

		if (/<\/DL/) {

			print for sort { helper($a, $b) } @hrefs;

			print; # </DL><p>
			last;

		}

		# This function is recursive.

		sort_bookmarks() if /<H3/; # <DT><H3 ...>Folder</H3>

	}

}

#  _         _
# /  _ .__  |_  ._  __|_o _ ._  _.|o_|_
# \_(_)|(/_ ||_|| |(_ |_|(_)| |(_||| |_\/
#                                      /

usage if $help_flag; while (<>) { last if /bar/; print; } sort_bookmarks();

#  _
# | \ _  _   ._ _  _ .__|_ _._|_o _ ._
# |_/(_)(_|_|| | |(/_| ||_(_| |_|(_)| |

=head1 NAME

sort.pl - a recursive, command-line bookmark sorter

=head1 SYNOPSIS

perl sort.pl [options] <bookmark file> > [sorted bookmark file]

=head1 DESCRIPTION

A script to sort bookmarks from the command line.  Bookmarks are sorted
recursively and sink beneath any subfolders in the same parent folder.  The
script only operates on bookmarks; folder ordering is retained.  This script is
more powerful than Chrome's built-in bookmark-sorting feature because it works
recursively throughout all folders at once.

=head1 OPTIONS

=over

=item B<-i>, B<--ignore-case>

Sort bookmarks case-insensitively.

=item B<-s>, B<--switch>

By default, this script sorts bookmarks by their names.  To have it sort the
bookmarks by their URLs, pass the B<--switch> flag.

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
