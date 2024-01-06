#!/usr/bin/env perl

# FILENAME: bookmarklet-parser.pl
# AUTHOR: Zachary Krepelka
# DATE: Friday, January 5th, 2024

=begin comment

USAGE

	perl bookmarklet-parser.pl <input js file> <output html file>

PURPOSE

	The purpose of this script is to parse JavaScript code into a Netscape
	bookmark file containing bookmarklets that one can then import into a
	web browser.  A bookmarklet is a bookmark containing JavaScript code.

FILE FORMAT SPECIFICATION

	The input file should adhere to this file format specification.

	The file contains blocks delimited by BEGIN and END.  The delimiters are
	placed at the beginning of a new line.  The blocks are *not* nested.
	Each block contains valid JavaScript code constituting one bookmarklet.

	All other keywords appear inside blocks.  The following are keywords if
	placed at the beginning of a new line:

		BEGIN    [title]                    keyword is required
		END                                 keyword is required
		ICON     [file path]                keyword is optional
		PARAMS   [comma-delimited list]     keyword is optional
		ARGS     [comma-delimited list]     keyword is optional

	Some keywords accept arguments.

	The argument passed to BEGIN is the title of the bookmarklet.  It will
	appear as the name of the bookmark when imported into a web browser.
	Everything after the keyword up until the end of the line is eaten up.

	The ICON keyword expects the file path of an icon stored on the local
	machine.  This will become the favicon of the bookmark when imported
	into a web browser.  Everything after the keyword up until the end of
	the line is eaten up.  Please only specify one file with the .ico
	extension.

	Everything within a BEGIN-END block is automatically wrapped in an
	immediately invoked function expression.  The keywords PARAMS and ARGS
	pertain to this detail.  An IIFE for short looks like this:

		(function () { /* ... */ })();

	Sometimes it's useful to specify parameters and pass arguments.

		(function (document) { /* ... */ })(document);

	That's what PARAMS and ARGS do.  Recall the difference between
	parameters and arguments: arguments are values passed into functions
	whereas parameters are variables declared in a function's definition.
	Arguments are bounded to parameters when a function enters into scope.

MINIMAL WORKING EXAMPLE

	Create a file on your machine with the following contents.  Make sure
	it's in the same directory as this script.  You might name it something
	like 'hello-world.js,' but since our file format isn't truly valid
	JavaScript, you might also consider making up your own file extension
	like '.bml' for [b]ook[m]ark[l]et.  You can put as many bookmarklets as
	you want in a .bml file, but let's stick to just one for now.

		FILENAME: hello-world.bml

		01  BEGIN Greeter
		02
		03  // This is an inline comment.
		04
		05  alert("Hello, World!");
		06
		07  /*
		08   * This is a block comment.
		09   * Will it work?
		10   * Let's find out.
		11   *
		12   */
		13
		14  END

	Now enter this on the command line:

		perl bookmarklet-parser.pl hello-world.bml > bookmarklets.html

	The last step is to import 'bookmarklets.html' into your web browser
	just like you would for any other bookmark file.

EXTENDED EXAMPLE

	Wikipedia gives the following example of a bookmarklet.  See here:
	https://en.wikipedia.org/wiki/Bookmarklet#Example.

		FILENAME: wiki-search.js

		01  javascript:(function(document) {
		02
		03  function se(d) {
		04  	return d.selection ?
		05  		d.selection.createRange(1).text :
		06  		d.getSelection(1);
		07  };
		08
		09  let d = se(document);
		10
		11  for (
		12  	i = 0;
		13  	i < frames.length && (d==document || d=='document');
		14  	i++
		15  )
		16  	d = se(frames[i].document);
		17
		18  if (d=='document')
		19  	d = prompt('Enter%20search%20terms,'');
		20
		21  open('https://en.wikipedia.org' +
		22  	(d ? '/w/index.php?title=Special:Search&search=' +
		23  		encodeURIComponent(d) : '')).focus();
		24
		25  })(document);

	We can translate this into our language like this:

		01  BEGIN Wikipedia Searcher
		02
		03  ICON javascript.ico
		04  PARAMS document
		05  ARGS document
		06
		07  function se(d) {
		08  	return d.selection ?
		09  		d.selection.createRange(1).text :
		10  		d.getSelection(1);
		11  };
		12
		13  let d = se(document);
		14
		15  for (
		16  	i=0;
		17  	i<frames.length && (d==document || d=='document');
		18  	i++
		19  )
		20  	d = se(frames[i].document);
		21
		22  if (d=='document')
		23  	d = prompt('Enter%20search%20terms','');
		24
		25  open('https://en.wikipedia.org' +
		26  	(d ? '/w/index.php?title=Special:Search&search=' +
		27  		encodeURIComponent(d) : '')).focus();
		28
		29  END

REMARK

	Since bookmarklets are powered by JavaScript, I like to give them a
	JavaScript icon.  If you're on the command line, you might try this:

		wget https://raw.githubusercontent.com/edent/SuperTinyIcons
			/master/images/svg/javascript.svg

		convert -resize 16x16 javascript.svg javascript.ico

MOTIVATIONS

	Why do we need a tool like this?  Let me explain.  The typical way of
	creating a bookmarklet is by copy-and-pasting JavaScript into the URL
	box when adding or editing a bookmark.  Internally, the JavaScript code
	is stored entirely within the HREF attribute of an HTML anchor.
	Accordingly, the browser will automatically compress your code into a
	single line.  Additionally, some characters are translated into other
	characters.  This looks ugly; the code is unreadable.  This mandates
	storing your bookmarklet code in a readable format as a backup.

	The process of copy-and-pasting is tedious.  Moreover, there are
	characters that can break HTML encoding, so you have to be careful.
	Many online tools exist to help with these issues, but none of them
	really suited my needs.  I wanted a tool that can compile bookmarklets
	in bulk.  Moreover, I wanted something that works from the command line.
	I wrote this script to suit my needs.

=end comment

=cut


# |\/| _  _|   | _  _
# |  |(_)(_||_||(/__>

use strict;
use warnings;
use MIME::Base64 qw(encode_base64);  # https://metacpan.org/pod/MIME::Base64
use URI::Escape qw(uri_escape_utf8); # https://metacpan.org/pod/URI::Escape


# \  /_.._o _.|_ | _  _
#  \/(_|| |(_||_)|(/__>

my $user = "Zachary"; # Change this if you're not me!

my $anchors = "";
my $href    = "";
my $icon    = "";
my $title   = "";
my $args    = "";
my $params  = "";


#  __
# (_    |_ .__   _|_o._  _  _
# __)|_||_)|(_)|_||_|| |(/__>

sub reset_vars {

	$href   = "";
	$icon   = "";
	$title  = "";
	$args   = "";
	$params = "";

}

sub trim {

	my $str = shift;
	$str =~ s/^\s+|\s+$//g;
	return $str;

}

sub encode_ico {

	open (IMAGE, shift) || die $!;

	return
		encode_base64(
			do {
				local $/ = undef;
				<IMAGE>;
			},
		'');

	# Special variables like $! and $/ are explained here:

		# https://perldoc.perl.org/variables
}

=begin comment

	The code inside the following subroutine, including comments, is
	entirely accredited to John Gruber, the inventor of Markdown.  It's his
	code, not mine.  See the following links for more details.

	https://en.wikipedia.org/wiki/John_Gruber
	https://daringfireball.net/2007/03/javascript_bookmarklet_builder
	https://gist.github.com/gruber/8658935

=end comment

=cut

sub encode_js {

	my $javascript = shift;

	for ($javascript) {
		s{(^\s*//.+\n)}{}gm;        # Kill commented lines
		s{^\s*/\*.+?\*/\n?}{}gms;   # Kill block comments
		s{\t}{ }gm;                 # Tabs to spaces
		s{[ ]{2,}}{ }gm;            # Space runs to one space
		s{^\s+}{}gm;                # Kill line-leading whitespace
		s{\s+$}{}gm;                # Kill line-ending whitespace
		s{\n}{}gm;                  # Kill newlines
	}

	return 'javascript:' . uri_escape_utf8($javascript);
}


#  _         _                   _
# /  _ .__  |_).__  _ .__.._ _  |_  ._  __|_o _ ._  _.|o_|_
# \_(_)|(/_ |  |(_)(_||(_|| | | ||_|| |(_ |_|(_)| |(_||| |_\/
#                   _|                                     /

while (my $line = <>) {

	if ($line =~ m/^ARGS(.*)$/) {

		$args = trim $1;

	} elsif ($line =~ m/^PARAMS(.*)$/) {

		$params = trim $1;

	} elsif ($line =~ m/^ICON(.*)$/) {

		$icon = encode_ico(trim $1);
		$icon = ' ICON="data:image/png;base64,' . $icon . '"';

	} elsif ($line =~ m/^BEGIN(.*)$/) {

		reset_vars();
		$title = trim $1;

	} elsif ($line =~ m/^END/) {

		$href =
			' HREF="' .
			encode_js(
				'(function(' .
				$params      .
				'){'         .
				$href        .
				'})('        .
				$args        .
				');'
			) . '"';

		$anchors .= "<DT><A$href$icon>$title</A>\n";

	} else {

		$href .= $line;

	}

}

chomp $anchors;
my $pad = " " x 8;
$anchors =~ s/^/$pad/gm;

my $document = <<"EOF";
<!DOCTYPE NETSCAPE-Bookmark-file-1>

<!--
	 ___           _                  _   _     _
	| _ ) ___  ___| |___ __  __ _ _ _| |_| |___| |_ ___
	| _ \\/ _ \\/ _ \\ / / '  \\/ _` | '_| / / / -_)  _(_-<
	|___/\\___/\\___/_\\_\\_|_|_\\__,_|_| |_\\_\\_\\___|\\__/__/

	This file was generated with a Perl script written by Zachary Krepelka.

		https://github.com/zachary-krepelka/bookmarks
-->

<TITLE>${user}'s Bookmarklets</TITLE>
<H1>${user}'s Bookmarklets</H1>

<DL><p>
    <DT><H3>Bookmarklets</H3>
    <DL><p>
$anchors
    </DL><p>
</DL>
EOF

print $document;
