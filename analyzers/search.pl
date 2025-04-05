#!/usr/bin/env perl

# FILENAME: search.pl
# AUTHOR: Zachary Krepelka
# DATE: Wednesday, May 1st, 2024
# ABOUT: a command-line bookmark searcher
# ORIGIN: https://github.com/zachary-krepelka/bookmarks.git
# UPDATED: Friday, April 4th, 2025 at 11:12 PM

use strict;
use warnings;
use File::Basename;
use File::Temp qw(tempfile);
use Getopt::Long;

my @urls;
my @folders;
my %bookmarks = ();
my $where_processing_begins = qr/^    <DT>/;

GetOptions(
	'name'   => \my $name_flag,
	'url'    => \my $url_flag,
	'path'   => \my $path_flag,
	'folder' => \my $folder_flag,
	'help'   => \my $help_flag
);

#  __
# (_    |_ .__   _|_o._  _  _
# __)|_||_)|(_)|_||_|| |(/__>

sub usage {

	my $program = basename($0);
	print STDERR <<~USAGE;
		Usage: $program [bookmark file]
		Command-line Bookmark Searcher

		Options:
			-n, --name	search by name
			-u, --url	search by URL
			-p, --path	search by path
			-f, --folder	search for a folder
			-h, --help	display this help message

		Documentation: perldoc $program
		Example:       perl $program -n bookmarks.html
		USAGE
	exit;
}

sub get_bookmarks_by_name {

	my $key;
	my $value;

	while (<>) {

			if (m|((?<=>)[^>]*(?=</A>))|) {

				$key = $1;

			} else {

				next;

			}

			if (/HREF="([^"]+)/) {

				$value = $1;

			} else {

				next;

			}

		$bookmarks{$key} = $value;

	}
}

sub get_bookmarks_by_path {

	while (<>) { last if /$where_processing_begins/; }

	my @path;

	while (<>) {

		push @path, $1 if m|((?<=>)[^>]*(?=</H3>))|;

		if (m|((?<=>)[^>]*(?=</A>))|) {

			push @path, $1;

			$bookmarks{join "/", @path} = $1 if /HREF="([^"]+)/;

			pop @path;

		}

		pop @path if /<\/DL><p>/;
	}
}

sub get_urls {

	while (<>) { push @urls, $1 if /HREF="([^"]+)/; }
}

sub get_folders {

	while (<>) { push @folders, $1 if m|((?<=>)[^>]*(?=</H3>))|; }
}

#  _         _
# /  _ .__  |_  ._  __|_o _ ._  _.|o_|_
# \_(_)|(/_ ||_|| |(_ |_|(_)| |(_||| |_\/
#                                      /

my @search_terms;

if ($name_flag) {

	get_bookmarks_by_name();
	@search_terms = keys %bookmarks;

} elsif ($url_flag) {

	get_urls();
	@search_terms = @urls;

} elsif ($path_flag) {

	get_bookmarks_by_path();
	@search_terms = keys %bookmarks;

} elsif ($folder_flag) {

	get_folders();
	@search_terms =  @folders;

} else { usage; }

my ($fh, $filename) = tempfile;
print $fh join("\n", @search_terms);
chomp(my $input = `cat $filename | fzf`);

if ($folder_flag) {

	# In lieu of opening the URL directly, we copy it to the clipboard.

		# https://stackoverflow.com/q/53694504

	system("echo 'chrome://bookmarks/?q=$input' | clip.exe");

} else {

	my $url = $url_flag ? $input : $bookmarks{$input};

	system("cmd.exe /c start chrome $url");

} # if

__END__

#  _
# | \ _  _   ._ _  _ .__|_ _._|_o _ ._
# |_/(_)(_|_|| | |(/_| ||_(_| |_|(_)| |

=head1 NAME

search.pl - a command-line bookmark searcher using fzf

=head1 SYNOPSIS

perl search.pl <option> <bookmark file>

=head1 DESCRIPTION

A script to search your bookmarks from the command line and open the result in a
web browser.  The input is a file in the Netscape Bookmark file format.  The
script currently targets Chrome on WSL.  Unlike Chrome's built-in search
feature, this script gives you a wider variety of search techniques.  You can
search for a bookmark by name, by URL, and by path. You can also search for
folders.

=head1 OPTIONS

=over

=item B<-n>, B<--name>

Search for bookmarks by name.

=item B<-u>, B<--url>

Search for bookmarks by URL.

=item B<-p>, B<--path>

Search for bookmarks by path. Unlike the other options, this one respects the
hierarchical structure of the data. Think nested versus flattened.

=item B<-f> B<--folder>

Search for a folder. Copy the result to your clipboard as a URL.

=item B<-h>, B<--help>

Display a help message and exit.

=back

=head1 DEPENDENCIES

This script is a wrapper around fzf, a command-line fuzzy finder. You will need
to install fzf on your system to use this script. You can find the project on
GitHub at L<https://github.com/junegunn/fzf.git>.

=head1 CAVEATS

This script specifically targets Google Chrome on WSL because that's what I'm
using. I would like to generalize the script to run on a variety of systems, but
I'll save that for another day when I have more time.

=head1 BUGS

Certain URL characters need shell-escaped and will presently cause the program
to fail. This shouldn't be difficult to fix, but I don't have the time now.

=head1 SEE ALSO

This script is part of my GitHub repository.

	https://github.com/zachary-krepelka/bookmarks.git

This repository contains various scripts for bookmark management.

=head1 AUTHOR

Zachary Krepelka L<https://github.com/zachary-krepelka>

=cut

#
