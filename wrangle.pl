#!/usr/bin/env perl

# FILENAME: wrangle.pl
# AUTHOR: Zachary Krepelka
# DATE: Wednesday, May 22nd, 2024
# ABOUT: a tool to idenfity misplaced bookmarks
# ORIGIN: https://github.com/zachary-krepelka/bookmarks.git
# UPDATED: Thursday, May 23rd, 2024 at 11:40 PM

#
# |\/| _  _|   | _  _
# |  |(_)(_||_||(/__>

use strict;
use warnings;
use feature qw(say);
use File::Basename;
use Getopt::Long;

#
# \  /_.._o _.|_ | _  _
#  \/(_|| |(_||_)|(/__>

my @path;
my %outliers;
my $where_folder_begins = qr/<H3/;
my $where_folder_ends = qr/<\/DL/;

GetOptions(
	'help'  => \my $help_flag,
	'print-rules|p' => \my $print_rules_flag,
	'print-exempt|q' => \my $print_exempt_flag
);

#  __
# (_    |_ .__   _|_o._  _  _
# __)|_||_)|(_)|_||_|| |(/__>


sub usage {

	my $program = basename $0;
	print STDERR <<~USAGE;
		Usage: $program {bookmark file} > [html report file]
		Report misplaced bookmarks using a rule-based system

		Options:
			-p, --print-rules    print the rules
			-q, --print-exempt   print folders without rules
			-h, --help           display this help message

		Documentation: perldoc $program
		Example: $program bookmarks.html > report.html
		USAGE
	exit;
}

sub extract_anchor {

	if (shift =~ /<A HREF="([^"]+)"[^>]*>([^<]*)<\/A>/) {

		# cuts out the [^>]*, e.g., ICON="..."

		return "<a href=\"$1\">$2</a>";

	}

}

sub enter_folder { m|((?<=>)[^>]*(?=</H3>))| ? push @path, $1 : die; }

sub exit_folder { pop @path; }

sub print_rules {

	enter_folder;

	while (<>) {

		if (/HREF="folder-content-rule:([^"]+)"/) {

			say((join "/", @path) . "\n\n\t$1\n");

		}

		if (/$where_folder_ends/) {

			exit_folder;
			return;
		}

		print_rules() if /$where_folder_begins/;

	}

}

sub print_exempt {

	enter_folder;

	my $flag = shift;

	while (<>) {

		$flag = 1 if /folder-content-rule/;

		if (/$where_folder_ends/) {

			unless(defined $flag) {

				say join "/", @path;

			}

			exit_folder;
			return;
		}

		print_exempt($flag) if /$where_folder_begins/;

	}

}

sub find_outliers {

	enter_folder;

	my $rule = shift;
	my @bookmarks = ();

	while (<>) {

		$rule = $1 if /HREF="folder-content-rule:([^"]+)"/;

		push @bookmarks, extract_anchor $_ if /<A/;

		if (/$where_folder_ends/) {

			goto GOODBYE unless defined $rule;

			my @outliers = ();

			foreach my $bookmark (@bookmarks) {

				if (index($bookmark, $rule) == -1) {

					push @outliers, $bookmark;

				}

			}

			$outliers{join "/", @path} = [ @outliers ] if @outliers;

			GOODBYE: exit_folder; return;

		}

		find_outliers($rule) if /$where_folder_begins/;

	}

}

#  _         _
# /  _ .__  |_  ._  __|_o _ ._  _.|o_|_
# \_(_)|(/_ ||_|| |(_ |_|(_)| |(_||| |_\/
#                                      /

usage if $help_flag;

while (<>) { last if /bar/; }

if ($print_rules_flag) {

	print_rules();

	exit;

}

if ($print_exempt_flag) {

	print_exempt();

	exit;

}

find_outliers();

if (%outliers) {

	print <<~'REPORT';
	<!--
	   _________________________________________
	  / Thanks for stopping by. This file was   \
	  | generated with a Perl script written by |
	  \ Zachary Krepelka.                       /
	   -----------------------------------------
	          \   ^__^
	           \  (oo)\_______
	              (__)\       )\/\
	                  ||----w |
	                  ||     ||

	  https://github.com/zachary-krepelka/bookmarks.git
	-->
	<html>
	  <head>
	    <title>Report</title>
	    <style>
	      a {
	        color: inherit;
	        text-decoration: inherit;
	      }
	      div {
	        width: 450px;
	        word-wrap: break-word;
	      }
	      html, body {
	        height: 100%;
	      }
	      html {
	        display: table;
	        margin: auto;
	      }
	      body {
	        display: table-cell;
	        vertical-align: middle;
	      }
	    </style>
	  </head>
	  <body>
	    <h1>Misplaced Bookmarks Report</h1>
	    <div>
	      <p>
		This report was generated with a Perl script written by Zachary
		Krepelka.  The script runs against a bookmark file exported from
		a web browser.  The user defines rules about what kind of
		bookmarks are allowed to be in particular folders.  If those
		rules are broken, the infringing bookmarks are reported here as
		clickable links.
	      </p>
	    </div>
	    <hr>
	REPORT

	foreach my $folder ( sort keys %outliers ) {

		print <<~REPORT;
		    <section>
		      <h2>$folder</h2>
		      <ul>
		REPORT

		say "  " x 4 . "<li>$_</li>" for $outliers{$folder}->@*;

		print <<~'REPORT';
		      </ul>
		    </section>
		    <hr>
		REPORT

	}

	print <<~'REPORT';
	    <footer>
	      Find the Perl script
	      <a href="https://github.com/zachary-krepelka/bookmarks">here</a>.
	    </footer>
	  </body>
	</html>
	REPORT
}

__END__

#  _
# | \ _  _   ._ _  _ .__|_ _._|_o _ ._
# |_/(_)(_|_|| | |(/_| ||_(_| |_|(_)| |

=head1 NAME

wrangle.pl - wrangle up misplaced bookmarks into a report using rules

=head1 SYNOPSIS

perl wrangle.pl [options] {bookmark file} > [html report]

=head1 DESCRIPTION

This one's a little bit harder to explain than my others.  Before anything else,
it will help to explain the problem that motivated me to write this script.

=head2 The Problem

I keep and compile a lot of bookmarks in my web browser.  They are organized
into a deeply nested folder structure.

I often organize the contents of the folders according to patterns or rules.
For example, I might require that a folder called 'Shopping' should only contain
links to Amazon.

The problem is that sometimes bookmarks end up in the wrong folders.  This
happens when I'm not being careful, which is more often than not.  I wanted a
way to identify when this happens without manually looking through hundreds of
folders and thousands of bookmarks.

=head2 The Solution

That's what this script is for.  It provides a way to establish rules that
dictate the expected contents of a folder.  This script operates on a bookmark
file exported from a web browser.  It generates a report that lets the user know
where these rules are violated.

=head2 Where are the rules specified?

They are specified within the bookmark file itself.  To establish a rule for a
specific folder, you will place a special kind of bookmark called a rule in that
folder.  The rule will apply recursively to all bookmarks in every subfolder.  A
rule in a subfolder will override its parent's rule in its own subfolders.

You can define as many rules as you want, but keep it to one per folder.  The
last one in the folder will take priority.


=head2 How are the rules specified?

With a special bookmark, which you might name 'Rule.'  The URL of this bookmark
starts with a special keyword:

	folder-content-rule:

Anything after this keyword is a pattern to be matched against.  If the pattern
does not match, the rule is violated.

Currently, I take the word 'match' to mean "be a substring of". Later, when I
have more time, I would like to adapt the program to use regular expressions
instead.

=head2 Quick Example

Create a bookmark in your shopping folder with the following URL:

	folder-content-rule:https://www.amazon.com

Export your bookmarks as an HTML file and run this script on that file.  This
script will generate a report.  That report will list any violations of folder
content rules.  In this case, if your shopping folder mistakenly contains a
Wikipedia article, you'll be made aware.

=head1 OPTIONS

Recall that a folder's rule applies recursively to all subfolders.  A
folder has a rule if its parent has a rule.

=over

=item B<-h>, B<--help>

Display a help message and exit.

=item B<-p>, B<--print-rules>

Suppress normal output.  Instead, print out the folder content rules to the
terminal for review.

=item B<-q>, B<--print-exempt>

Suppress normal output.  Instead, print out a list of folders that do not have
rules.  This flag is superseded by the B<--print-rules> flag if they are
specified together.

=back

=head1 EXAMPLE

I'll write a more detailed example later.

=head1 SEE ALSO

This script is part of my GitHub repository.

	https://github.com/zachary-krepelka/bookmarks.git

This repository contains various scripts for bookmark management.

=head1 AUTHOR

Zachary Krepelka L<https://github.com/zachary-krepelka>

=cut

#
