#!/usr/bin/env perl

# FILENAME: bookmarklet-parser.pl
# AUTHOR: Zachary Krepelka
# DATE: Friday, January 5th, 2024

=begin comment

USAGE

	perl bookmarklet-parser.pl [input js file] > [output html file]

PURPOSE

	The purpose of this script is to parse JavaScript code into a Netscape
	bookmark file containing bookmarklets that one can then import into a
	web browser.  This allows the user to store bookmarklet source code in a
	readable format while still having the ability to quickly compile the
	source code into an importable file.

MOTIVATIONS

	A bookmarklet is a bookmark that contatins JavaScript code.  When the
	bookmark is opened, its code is executed.  Bookmarklets provide small
	units of functionality to the web browser.

	The typical way of creating a bookmarklet entails copy-and-pasting
	JavaScript code into the URL box when adding or editing a bookmark.
	Internally, the JavaScript code is stored entirely within the HREF
	attribute of an HTML anchor.  Accordingly, the browser automatically
	compresss your code into a single line.  It also translates HTML-invalid
	characters.  Bottom line, the code is unreadable.  This mandates storing
	your bookmarklet code in a readable format as a backup.  For
	copy-and-pasting conveinece, many people share their bookmarklet code in
	a one-line format. Can anyone tell me what this does at first glance?

		javascript:(function(document){function se(d){return d.selection
		?d.selection.createRange(1).text:d.getSelection(1);};letd=se(doc
		ument);for(i=0;i<frames.length&&(d==document||d=='document');i++
		)d=se(frames[i].document);if(d=='document')d=prompt('Enter%20sea
		rch%20terms%20for%20Wikipedia','');open('https://en.wikipedia.or
		g'+(d?'/w/index.php?title=Special:Search&search='+encodeURICompo
		nent(d):'')).focus();})(document);

	Readability is a must, but copy-and-pasting is tedious.  Comments have
	to be removed.  Characters that break HTML encoding can pose problems.
	Many online tools exist to help with these issues, but none of them
	suited my needs.

	I wanted a tool that

		* promotes source code readabiltiy.
		* compiles bookmarklets in bulk.
		* works from the command line.

	I wrote this script to suit my needs.

FILE FORMAT SPECIFICATION

	The input file should adhere to this file format specification.

	The file consists of blocks delimited by BEGIN and END.  The delimiters
	are placed at the beginning of a new line.  The blocks are *not* nested.
	Each block contains valid JavaScript code constituting one bookmarklet.

	The following are keywords if placed at the beginning of a new line:

		---------------------------------------------------------
		KEYWORD     ARGUMENTS                SCOPE      CONDITION
		---------------------------------------------------------
		BEGIN       bookmark name            n/a        required
		END         n/a                      n/a        required
		ICON        file path                local      optional
		ARGS        comma-delimited list     local      optional
		PARAMS      comma-delimited list     local      optional
		NAME        user's name              global     optional
		---------------------------------------------------------

	Some keywords accept arguments.

	The argument passed to BEGIN is the title of the bookmarklet.  It will
	appear as the name of the bookmark when imported into a web browser.
	Everything after the keyword up until the end of the line is eaten up.

	The ICON keyword expects the file path of an icon stored on the local
	machine.  This will become the favicon of the bookmark when imported
	into a web browser.  Everything after the keyword up until the end of
	the line is eaten up.  Please only specify one file with the .ico
	extension.

	The NAME keyword injects the user's name into the heading of the HTML
	file.  This is only noticeable if you open the resulting file as apposed
	to only importing it.

	Everything within a BEGIN-END block is automatically wrapped in an
	immediately invoked function expression.  The keywords PARAMS and ARGS
	pertain to this detail.  An IIFE for short looks like this:

		(function () { /* ... */ })();

	Sometimes it's useful to specify parameters and pass arguments.

		(function (document) { /* ... */ })(document);

	That's what PARAMS and ARGS do.  Recall the difference between
	parameters and arguments: arguments are values passed into function
	calls whereas parameters are variables declared in a function's
	definition.  Arguments are bound to parameters when a function enters
	into scope.

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

	Notice that the IIFE is taken care of for us. Its parameters and
	arguments are addressed with keywords.

REMARK

	Since bookmarklets are powered by JavaScript, I like to give them a
	JavaScript icon.  If you're on the command line, you might try this:

		wget https://raw.githubusercontent.com/edent/SuperTinyIcons
			/master/images/svg/javascript.svg

		convert -resize 16x16 javascript.svg javascript.ico

	But you can choose whatever icon you want. Just provide the file path.

TODO

	Add CoffeeScript support

		Maybe do this with a LANG keyword

	Do error catching if

		$anchors is empty

		the image file cannot be found

	Consider writing to a file instead of printing

	Maybe add a sorting feature

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

my $user    = "";
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

	if ($line =~ m/^NAME(.*)$/) {

		next if $1 =~ m/^\s*$/;
		$user = trim($1) . "'s ";

	} elsif ($line =~ m/^ARGS(.*)$/) {

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

<TITLE>${user}Bookmarklets</TITLE>
<H1>${user}Bookmarklets</H1>

<DL><p>
    <DT><H3>Bookmarklets</H3>
    <DL><p>
$anchors
    </DL><p>
</DL>
EOF

print $document;

# UPDATED: Saturday, January 6th, 2024   2:40 PM
