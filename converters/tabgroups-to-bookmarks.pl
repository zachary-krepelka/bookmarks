#!/usr/bin/env perl

# FILENAME: tabgroups-to-bookmarks.pl
# AUTHOR: Zachary Krepelka
# DATE: Friday, April 19th, 2024
# ABOUT: Tab Groups Extension data converter
# ORIGIN: https://github.com/zachary-krepelka/bookmarks.git
# UPDATED: Saturday, April 20th, 2024 at 2:23 AM

use strict;
use warnings;
use feature qw( say );
use File::Basename;

if ($ARGV[0] eq '-h' || $ARGV[0] eq '--help')
{
	my $prog = basename($0);
	print STDERR <<~USAGE;
		Usage: $prog [tabgroups file] > [bookmark file]
		Convert HTML from the Tab Group Extension to a bookmark file

		Documentation: perldoc $prog
		Options:       -h to display this help message
		USAGE
	exit;
}

print <<'EOF';
<!DOCTYPE NETSCAPE-Bookmark-file-1>

<!--
	 ___       __
	  | _.|_  /__.__    ._  _
	  |(_||_) \_||(_)|_||_)_>
			    |

	This file was generated with a Perl script written by Zachary Krepelka.

		https://github.com/zachary-krepelka/bookmarks.git
-->

<TITLE>Tab Groups</TITLE>
<H1>Tab Groups</H1>

<DL><p>
    <DT><H3>Tab Groups</H3>
    <DL><p>
EOF

my $data = <>;

$data =~ s/.*?<ul>//;

my @groups = $data =~ m|<li>.*?<ul>.*?</ul>|g;

for my $group (@groups) {

	my $title = $1 if $group =~ m|.*? ([^<]*)|;
	my @anchors = $group =~ m|<a.*?</a>|g;

	say ' ' x 8 . "<DT><H3>$title</H3>";
	say ' ' x 8 . '<DL><p>';

	for my $anchor (@anchors) {

		$anchor =~ s|(<a href)|\U$1|;
		$anchor =~ s|(</a>)|\U$1|;

		say ' ' x 12 . '<DT>' . $anchor;

	} # for

	say ' ' x 8 . '</DL><p>';

} # for

print <<'EOF';
    </DL><p>
</DL><p>
EOF

__END__

=head1 NAME

tabgroups-to-bookmarks.pl - Tab Group Data to Bookmark File Converter

=head1 SYNOPSIS

perl tabgroups-to-bookmarks.pl tabgroups_data.html > bookmarks.html

=head1 DESCRIPTION

The I<Tab Groups Extension> is a web browser add-on developed by Guokai Han for
Google Chrome and Microsoft Edge. It is used to "automatically group tabs, save
tabs/groups, and provide shortcuts for tabs/groups".  The extension allows the
user to export saved groups of tabs to an html file called
C<tabgroups_data_YYYYMMDD.html>.

The purpose of this script is to convert these files into the Netscape bookmark
file format so that they can be imported into a web browser natively.

=head1 SEE ALSO

This script is part of my GitHub repository.

	https://github.com/zachary-krepelka/bookmarks.git

This repository contains various scripts for bookmark management.

You can find the extension this script targets at L<https://guokai.dev/>.
Find the extension's author's GitHub at L<https://github.com/hanguokai>.

=head1 AUTHOR

Zachary Krepelka L<https://github.com/zachary-krepelka>

=cut

#
