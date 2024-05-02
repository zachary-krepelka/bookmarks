#!/usr/bin/env perl

# FILENAME: search.pl
# AUTHOR: Zachary Krepelka
# DATE: Wednesday, May 1st, 2024
# ABOUT: a perl script to search bookmarks
# ORIGIN: https://github.com/zachary-krepelka/bookmarks.git

use strict;
use warnings;
use File::Basename;
use File::Temp qw(tempfile);
use Getopt::Long;

my $key;
my $value;
my @folders;
my %bookmarks = ();

GetOptions(
	'folders' => \my $folder_flag,
	'help' => \my $help_flag,
	'url' => \my $url_flag

);

if ($help_flag)
{
	my $program = basename($0);
	print STDERR <<~USAGE;
		Usage: $program [bookmark file]
		Command-line Bookmark Searcher

		Options:
			-h, --help	display this help message
			-u, --url	search by URL
			-f, --folder	search by folder

		Default:       search by name
		Example:       perl $program bookmarks.html
		Documentation: perldoc $program
		USAGE
	exit;
}


while (<>) {

		if (m|((?<=>)[^>]*(?=</H3>))|) {

			push @folders, $1;

			next;

		} # if

		if (m|((?<=>)[^>]*(?=</A>))|) {

			$key = $1;

		} else {

			next;

		} # if

		if (/HREF="([^"]+)/) {

			$value = $1;

		} else {

			next;

		} # if

	$bookmarks{$key} = $value;

} # while

my ($fh, $filename) = tempfile;

print $fh join("\n",

	$folder_flag ?

		@folders :

		$url_flag ?

			values %bookmarks :

			keys %bookmarks
);

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

=head1 NAME

search.pl - search your bookmarks with fzf from the CLI

=head1 SYNOPSIS

perl search.pl <bookmark file>

=head1 DESCRIPTION

A script to search your bookmarks from the command line and open the result in a
web browser.  The input is a file in the Netscape Bookmark file format.  The
script currently targets Chrome on WSL.  Unlike Chrome's built-in search
feature, this script allows you to search by name, by URL, and by folder.

=head1 OPTIONS

=over

=item B<-h>, B<--help>

Display a help message and exit.

=item B<-u>, B<--url>

Search by URL instead of by name.

=item B<-f> B<--folder>

Search by folder. Copy the result to your clipboard as a URL.

=back

=head1 SEE ALSO

This script is part of my GitHub repository.

	https://github.com/zachary-krepelka/bookmarks.git

This repository contains various scripts for bookmark management.

=head1 AUTHOR

Zachary Krepelka L<https://github.com/zachary-krepelka>

=cut

#
