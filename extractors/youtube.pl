#!/usr/bin/env perl

# FILENAME: youtube.pl
# AUTHOR: Zachary Krepelka
# DATE: Wednesday, September 17th, 2025
# ABOUT: extract and organize YouTube bookmarks
# ORIGIN: https://github.com/zachary-krepelka/bookmarks.git
# UPDATED: Thursday, September 18th, 2025 at 5:37 AM

#
# |\/| _  _|   | _  _
# |  |(_)(_||_||(/__>

use strict;
use warnings;
use feature qw(fc say);

use File::Basename;
use Getopt::Long qw(:config no_ignore_case);
use URI;

#
# \  /_.._o _.|_ | _  _
#  \/(_|| |(_||_)|(/__>

my @shorts          = ();
my @longs           = ();
my @playlists       = ();
my @channels        = ();
my @channel_content = ();
my @searches        = ();
my @misc            = ();

GetOptions(
	'help' => \my $help_flag,
	'docs|H' => \my $docs_flag
);

#  __
# (_    |_ .__   _|_o._  _  _
# __)|_||_)|(_)|_||_|| |(/__>

sub usage {
	my $program = basename $0;
	print <<~USAGE;
	Extract and organize YouTube bookmarks

	Usage:
	  perl $program [options] <netscape-bookmark-file>

	Options:
	  -h, --help  display this help message and exit
	  -H, --docs  read documentation for this script then exit

	Example:
	  perl youtube.pl bookmarks.html > youtube-bookmarks.html
	USAGE
	exit;
}

sub documentation {

	exec "pod2text $0 | less -Sp '^[^ ].*\$' +k"; exit;
}

sub make_folder {

	my $depth = shift;
	my $name = shift;
	my $contents = shift;

	say ' ' x (4 * $depth) . "<DT><H3>$name</H3>";
	say ' ' x (4 * $depth) . '<DL><p>';

	foreach my $anchor (@$contents) {

		say ' ' x (4 * $depth + 4) . $anchor;
	}
	say ' ' x (4 * $depth) . '</DL><p>';
}

sub compare {

	my ($a, $b) = map { fc $1 if m|>([^<]*)</|; } @_;

	return $a cmp $b;
}

#  _
# |_).__  _ _  _ _o._  _
# |  |(_)(_(/__>_>|| |(_|
#                      _|

usage if $help_flag; documentation if $docs_flag;

while (<>) {

	s/^\s+//; s/ - YouTube(?=<\/A>)//; chomp;

	if (m|HREF="(https://www.youtube.com/[^"]*)|) {

		my $anchor = $_;

		my $uri = URI->new($1);
		my @segments = $uri->path_segments;
		my $page = $segments[1];

		if ($page eq 'watch') {

			push @longs, $anchor;

		} elsif ($page eq 'shorts') {

			push @shorts, $anchor;

		} elsif ($page eq 'playlist') {

			push @playlists, $anchor;

		} elsif ($page eq 'results') {

			push @searches, $anchor;

		} elsif (
			$page eq 'channel' ||
			$page eq 'user' ||
			$page eq 'c' ||
			$page =~ /^@/) {

			my $threshold = $page =~ /^@/ ? 2 : 3;

			if (@segments == $threshold) {
				push @channels, $anchor;
			} else {
				$anchor =~ s/>\K(?=[^<]*<\/A>)/\U$segments[$threshold] /;
				push @channel_content, $anchor;
			}
		} else {
			push @misc, $anchor;
		}
	}
}

print <<'EOF';
<!DOCTYPE NETSCAPE-Bookmark-file-1>
<!-- This is an automatically generated file.
     It will be read and overwritten.
     DO NOT EDIT! -->
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<TITLE>Bookmarks</TITLE>
<H1>Bookmarks</H1>
<DL><p>
    <DT><H3>YouTube</H3>
    <DL><p>
        <DT><H3>Content</H3>
        <DL><p>
EOF

make_folder 3, "Shorts", [sort {compare($a, $b)} @shorts] if @shorts;
make_folder 3, "Longs", [sort {compare($a, $b)} @longs] if @longs;

print " " x 8 . "</DL><p>\n";

make_folder 2, "Playlists", [sort {compare($a, $b)} @playlists] if @playlists;
make_folder 2, "Channels", [sort {compare($a, $b)} @channels] if @channels;
make_folder 2, "Subpages", [sort {compare($a, $b)} @channel_content] if @channel_content;
make_folder 2, "Searches", [sort {compare($a, $b)} @searches] if @searches;
make_folder 2, "Misc", [sort {compare($a, $b)} @misc] if @misc;

print <<'EOF';
    </DL><p>
</DL><p>
EOF

__END__

#  _
# | \ _  _   ._ _  _ .__|_ _._|_o _ ._
# |_/(_)(_|_|| | |(/_| ||_(_| |_|(_)| |

=head1 NAME

youtube.pl - extract and organize YouTube bookmarks

=head1 SYNOPSIS

perl youtube.pl [options] <netscape-bookmark-file>

options: [ -h | -H ]

=head1 DESCRIPTION

Objective: given a Netscape bookmark file INPUT, to extract only
YouTube-related bookmarks from that file, and to subsequently
restructure those extracted bookmarks into a new Netscape bookmark file
OUTPUT with the following file structure.

	YouTube/
	|-- Content/
	|   |-- Shorts/
	|   |   `-- ...
	|   `-- Longs/
	|       `-- ...
	|-- Playlists/
	|   `-- ...
	|-- Channels/
	|   `-- ...
	|-- Subpages/
	|   `-- ...
	|-- Searches/
	|   `-- ...
	`-- Misc/
	    `-- ...

=head2 File Structure, Sorting Order, and Naming Conventions

The bookmarks are organized into several folders outlined below.  The
bookmarks in each folder are sorted by their names lexicographically in
a case-insensitive manner. If the INPUT file does not contain any
YouTube bookmarks of a particular kind, then the corresponding folder
will not be populated in the OUTPUT file.  The trailing C< - YouTube>
tag is stripped from the end of each bookmark name.

=over

=item 1) Content

This folder contains standalone playable content. It is divided into two
subfolders for short-form and long-form content.

=over

=item i) Shorts

Contains YouTube bookmarks with URLs of the form

	youtube.com/shorts/VIDEO_ID

=item ii) Longs

Contains YouTube bookmarks with URLs of the form

	youtube.com/watch?v=VIDEO_ID

This includes videos that are part of a playlist, e.g.,

	https://www.youtube.com/watch?v=VIDEO_ID&list=PLAYLIST_ID&index=NUM

=back

=item 2) Playlists

This folder contains bookmarked playlist pages.
These are bookmarks with URLs of the form

	youtube.com/playlist?list=PLAYLIST_ID

A dedicated playlist page is a standalone list of YouTube videos; it
does not play content but rather comprises a collection of content.  It
should not be confused with the playlist interface that often
accompanies videos.

=item 3) Channels

This folder contains bookmarked channel pages.
These are bookmarks with URLs of the form

	youtube.com/user/USERNAME
	youtube.com/channel/CHANNEL_ID
	youtube.com/c/CUSTOM_NAME
	youtube.com/@HANDLE

=item 4) Subpages

This folder contains sub pages belonging to specific channels.  These
are bookmarks with URLs of the form

	youtube.com/@HANDLE/SUBPAGE

Possible sub pages follow: featured, videos, shorts, streams, podcasts,
releases, playlists, posts, and store. These correspond to the tabs on a
YouTube channel page.

These bookmarks are placed into this folder as a flat list with the
following naming scheme.

	Subpages/
	|-- FEATURED some_channel
	|-- PLAYLISTS some_channel
	|-- PODCASTS some_channel
	|-- POSTS some_channel
	|-- RELEASES some_channel
	|-- SHORTS some_channel
	|-- STORE some_channel
	|-- STREAMS some_channel
	|-- VIDEOS some_channel
	`-- ...

This folder is like the C<Channels> folder; it contains the same set of
permissible URLs. Thereon, if one of the aforementioned URLs has a sub
path beyond the channel specifier, it is placed here instead of in the
C<Channels> folder.

=item 5) Searches

This folder contains bookmarked search queries.
These are bookmarks with URLs of the form

	youtube.com/results?search_query=WHAT_YOU_SEARCHED

Often it is the case that pages like these are bookmarked accidentally.
You may want to bookmark a search query if you are frequently returning
to it, e.g., in the case of an ongoing event in the news.

=item 6) Misc

This folder contains YouTube bookmarks that do not fall into any of the
previous categories.

=back

=head1 OPTIONS

=over

=item B<-h>, B<--help>

Display a [h]elp message and exit.

=item B<-H>, B<--docs>

Display this documentation in a pager and exit after the user quits.
The documentation is divided into sections.  Each section header is
matched with a search pattern, meaning that you can use navigation
commands like C<n> and its counterpart C<N> to go to the next or
previous section respectively.

The uppercase -H is to parallel the lowercase -h.

=back

=head1 CAVEATS

Only the standard domain is matched.

	https://www.youtube.com/...

Bookmarks using other domains, like those listed below, are not matched.

	https://youtu.be/...
	https://m.youtube.com/...
	etc.

=head1 SEE ALSO

This script is part of my GitHub repository.

	https://github.com/zachary-krepelka/bookmarks.git

This repository contains various scripts for bookmark management.

=head1 AUTHOR

Zachary Krepelka L<https://github.com/zachary-krepelka>

=cut
