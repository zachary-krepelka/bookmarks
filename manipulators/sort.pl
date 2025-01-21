#!/usr/bin/env perl

# FILENAME: sort.pl
# AUTHOR: Zachary Krepelka
# DATE: Sunday, May 19th, 2024
# ABOUT: a command-line bookmark sorter
# ORIGIN: https://github.com/zachary-krepelka/bookmarks.git
# UPDATED: Tuesday, January 21st, 2025 at 2:04 PM

#
# |\/| _  _|   | _  _
# |  |(_)(_||_||(/__>

use strict;
use warnings;
use File::Basename;
use Getopt::Long;
use HTML::Entities;

#
# \  /_.._o _.|_ | _  _
#  \/(_|| |(_||_)|(/__>

my @skips;
my $default_method = 'name';
my $where_folder_begins = qr/<H3/;
my $where_folder_ends = qr/<\/DL/;

GetOptions(
	'help'        => \my $help_flag,
	'ignore-case' => \my $case_insensitive,
	'method=s'    => \my $method,
	'skip-list=s' => \my $skip_list
);

#  __
# (_    |_ .__   _|_o._  _  _
# __)|_||_)|(_)|_||_|| |(/__>

sub usage {

	my $program = basename $0;
	print STDOUT <<~USAGE;
		Usage: $program [options] <bookmark file>
		a recursive, command-line bookmark sorter

		Options:
		  -h, --help                  display this help message
		  -i, --ignore-case           ignore case when sorting
		  -m STR, --method=STR        select sorting method
		  -s FILE, --skip-list=FILE   list of bookmarks to skip

		Methods:
		  name   sort bookmarks by name   <-- default
		  link   sort bookmarks by url
		  root   sort by root domain, then by name

		Documentation: perldoc $program
		USAGE
	exit;
}

sub extract_content {

	# Extracts the content of an html element

	decode_entities $1 if shift =~ m|>([^<]*)</|;
}

sub extract_url {

	# Extracts the href attribute value from an html anchor

	$1 if shift =~ /HREF="([^"]+)/i;
}

sub extract_domain {

	# Extracts only the root domain from an html anchor

	$1 if shift =~ m|HREF="[^:]+://([^/]+)|i;
}

sub process_skips {

	open my $fh, '<', $skip_list or die "The skip list failed.";

	while (<$fh>) { chomp; push @skips, $_; }

	close $fh;

}

my %methods = (
	name => sub { my ($a, $b) = map { extract_content $_ } @_; $a cmp $b; },
	link => sub { my ($a, $b) = map { extract_url     $_ } @_; $a cmp $b; },
	root => sub { my ($a, $b) = map { extract_domain  $_ } @_;

		my $result = $a cmp $b;

		unless ($result) {

			($a, $b) = map { extract_content $_ } @_;

			$result = $a cmp $b if defined $a && defined $b;
		}

		$result;
	}
);

my $compare =
	defined $method && exists $methods{$method} ?
	$methods{$method} : $methods{$default_method};

sub recurse {

	print;           # <DT><H3 ...>Folder</H3>
	print scalar <>; # <DL><p>

	my @hrefs = ();

	PROCESS_FOLDER_CONTENTS: while (<>) {

		if (defined $skip_list) {

			foreach my $skip (@skips) {

				if (/>\Q$skip\E</ and /<A/) {

					print; next PROCESS_FOLDER_CONTENTS;

		} } }

		push @hrefs, $_ if /<A/; # <DT><A HREF="..." ...>Bookmark</A>

		if (/$where_folder_ends/) {

			print for sort {

				my ($c, $d) = map {

					$case_insensitive ? lc $_ : $_

				} ($a, $b);

				&$compare($c, $d);

			} @hrefs;

			print; # </DL><p>
			last;

		}

		recurse() if /$where_folder_begins/; # <DT><H3 ...>Folder</H3>

	}

}

sub sort_bookmarks {

	while (<>) {
		last if /bar/;
		print;
	}

	recurse;

	print <>;
}

#  _         _
# /  _ .__  |_  ._  __|_o _ ._  _.|o_|_
# \_(_)|(/_ ||_|| |(_ |_|(_)| |(_||| |_\/
#                                      /

usage if $help_flag;

unless (@ARGV == 1) {

	print STDERR <<~MESSAGE;
	Exactly one argument is required.  Try -h for help.
	MESSAGE

	exit 1;
}

process_skips if defined $skip_list;
sort_bookmarks;

__END__

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
script only operates on bookmarks; folder ordering is retained.  For my use
case, this script is more powerful than Chrome's built-in sorting feature
because it works recursively throughout all folders at once.

=head1 OPTIONS

=over

=item B<-h>, B<--help>

Display a help message and exit.

=item B<-i>, B<--ignore-case>

Sort case insensitively.
May be used in conjunction with B<-m>.

=item B<-m> I<STR>, B<--method>=I<STR>

Sort according to the method specified by I<STR>.  See below.

=item B<-s> I<FILE>, B<--skip-list>=I<FILE>

I<FILE> is a list of names of bookmarks to skip when sorting.  Within a folder,
ignored bookmarks retain their original position, even with respect to
subfolders, while sorted bookmarks bubble down below both subfolders and
ignored bookmarks.

To be more precise, I<FILE> is a list of strings that are matched verbatimly
against raw HTML anchors.  As a consequence, either a URL or a name can be
used.  A sub string can also be used.  A drawback is that the string must be
HTML encoded, e.g., an ampersand must be written as &amp;

=back

=head1 METHODS

The following sorting methods are available.

=over

=item I<name>

Sort bookmarks by their names.  This is the default behavior.

    <a href="https://www.example.com/document.html">my bookmark</a>
                                                    -----------

=item I<link>

Sort bookmarks by their URLs.

    <a href="https://www.example.com/document.html">my bookmark</a>
             -------------------------------------

=item I<root>

Sort bookmarks by their root domains.

    <a href="https://www.example.com/document.html">my bookmark</a>
                     ---------------

Bookmarks with the same home page are sorted according to name.

=back

=head1 EXAMPLE

To sort bookmarks by their names in a case insensitive manner, but to first
organize them according to root domain, use this command:

    perl sort.pl -i -m root bookmarks.html > sorted-bookmarks.html

=head1 TODO

=head2 Short-Term Goals

I would like to implement the following command-line options.

=over

=item B<-r>, B<--recur>

The current behavior is to sort recursively.  There is no way to do a
surface-level sort.  The behavior I would like is to do a surface-level sort by
default and have the option to recur.

=item B<-t> I<PATH>, B<--target>=I<PATH>

Only sort below a specific folder.  The default target will be the root folder.

=back

=head2 Long-Term Goals

Currently this script can only sort bookmarks.  I want it to sort both
bookmarks and folders.  Because these two objects are inherently different, the
script should distinguish between them and provide different sorting methods
for each.  Some thought must go into how we want to model the user interface
for this.  Here are some possibilities.

=over

=item 1

We could choose to sort bookmarks by default but offer a switch like
B<--folder> to sort the folders instead.  The B<--method> option would
interpret its argument depending on the context with a different set of methods
being available for either bookmarks or folders.  Alas, this feels messy, and I
don't think it will scale well with future features.

=item 2

In order to keep the interface over bookmarks and folders distinct, we could
choose to implement sub commands each with their own command-line options.  We
would have a sub command for sorting folders and for sorting bookmarks.
Something like this:

	command [global options] subcommand [specific options] <args>

This is called the I<Swiss army knife> style.
L<https://superuser.com/q/1020583>

=item 3

We could implement a B<--type>=I<filter> option like the Linux find utility.
The default would be to sort both bookmarks and folders.

The complication is that we would like to allow for different sorting methods
on both bookmarks and folders.  One idea is to make the B<--method> option
accept key-value pairs, perhaps like this.

	-m <key>=<value>, --method=<key>=<value>

The B<-m> option could be passed multiple times to specify different pairs;
they do not have to be mutually exclusive.  See
L<https://stackoverflow.com/q/18115674>.

The set of keys could be C<bookmark>, C<folder>, and C<all>.  The arguments to
the B<-type> option would coincide with these keys.  Values for the C<all> key
might dictate how folders and bookmarks are organized relative to each other.
For example, we could have these.

=over

=item C<-m all=bubble>

Sub folders bubble to the top and bookmarks sink below.
Separate methods are used for sorting bookmarks and folders.

=item C<-m all=sink>

Sub folders sink to the bottom and bookmarks bubble to the top.
Separate methods are used for sorting bookmarks and folders.

=item C<-m all=name>

Individual sorting methods are disregarded.  Folders and bookmarks are sorted
at the same level by their names.  This will cause folders and bookmarks to be
interdispersed.

=back

The B<-type> option could be circumvented by allowing the C<bookmark> and
C<folder> keys to accept the value C<none>.  Every method key would assume a
default value, perhaps like this.

	folder=none
	bookmark=root
	all=bubble

This could even be passed as a config file.

=back

=head1 SEE ALSO

This script is part of my GitHub repository.

	https://github.com/zachary-krepelka/bookmarks.git

This repository contains various scripts for bookmark management.

=head1 AUTHOR

Zachary Krepelka L<https://github.com/zachary-krepelka>

=cut

#
