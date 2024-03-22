#!/usr/bin/env perl

# FILENAME: bookmarklet-parser.pl
# AUTHOR: Zachary Krepelka
# DATE: Friday, January 5th, 2024
# UPDATED: Friday, March 22nd, 2024 at 4:14 AM

=begin comment

USAGE

	perl bookmarklet-parser.pl [input js file] > [output html file]

PURPOSE

	The purpose of this script is to package JavaScript code into a Netscape
	bookmark file containing bookmarklets that one can then import into a
	web browser.  This allows the user to store bookmarklet source code in a
	readable format while still having the ability to quickly 'compile' the
	code into an importable file.

MOTIVATIONS

	A bookmarklet is a bookmark that contains JavaScript code.  When the
	bookmark is opened, its code is executed.  Bookmarklets provide small
	units of functionality to the web browser.

	The typical way of creating a bookmarklet entails copy-and-pasting
	JavaScript code into the URL box when adding or editing a bookmark.
	Internally, the JavaScript code is stored entirely within the HREF
	attribute of an HTML anchor.  Accordingly, the browser automatically
	compresses your code into a single line.  It also translates
	HTML-invalid characters.

	Bottom line, the code becomes unreadable.  This mandates storing your
	bookmarklet code in a readable format as a backup.  For copy-and-pasting
	convenience, many people share their bookmarklet code in a one-line
	format.  But there's a problem.  Can anyone tell me what this does at
	first glance?

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

		* promotes source code readability.
		* packages bookmarklets in bulk.
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
		LANG        programming language     local      optional
		NAME        user's name              global     optional
		SORT        n/a                      global     optional
		ROOT        folder name              global     optional
		ARGS        comma-delimited list     local      optional
		PARAMS      comma-delimited list     local      optional
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

	The LANG keyword only knows one message, and that's 'CoffeeScript.'  It
	allows the user to write bookmarklets in CoffeeScript.  If absent, the
	default language is JavaScript.

	The NAME keyword injects the user's name into the heading of the HTML
	file.  This is only noticeable if you open the resulting file as apposed
	to only importing it.

	The SORT keyword instructs the program to sort the bookmarks by title.

	The ROOT keyword's argument is the name of the root folder containing
	the bookmarklets. If the ROOT keyword is unspecified, the name will
	default to 'Bookmarklets.'

	Everything within a block is automatically wrapped in an immediately
	invoked function expression.  The keywords PARAMS and ARGS pertain to
	this detail.  An IIFE for short looks like this:

		(function () { /* ... */ })();

	Sometimes it's useful to specify parameters and pass arguments.

		(function (document) { /* ... */ })(document);

	That's what PARAMS and ARGS do.  Recall the difference between
	parameters and arguments: arguments are values passed into function
	calls whereas parameters are variables declared in a function's
	definition.  Arguments are bound to parameters when a function enters
	into scope.

MINIMAL WORKING EXAMPLE

	Create a file on your computer with the following contents.  Make sure
	it's in the same directory as this script.  You might name it something
	like 'hello-world.js,' but since our file format isn't truly valid
	JavaScript, you might consider making up your own file extension like
	'.bml' for [b]ook[m]ark[l]et.  You can put as many bookmarklets as you
	want in a .bml file, but let's stick to just one for now.

		FILENAME: hello-world.bml

		01  BEGIN Greeter
		02
		03  // This is an inline comment.
		04
		05  let person = prompt("What's your name?", "World");
		06
		07  alert(`Hello, ${person}!`);
		08
		09  /*
		10  * This is a block comment.
		11  * Will it work?
		12  * Let's find out.
		13  *
		14  */
		15
		16  END

	Now enter this on the command line:

		perl bookmarklet-parser.pl hello-world.bml > bookmarklets.html

	The last step is to import 'bookmarklets.html' into your web browser.

ANOTHER EXAMPLE

	Here's an example using CoffeeScript.

		01  BEGIN Greatest Common Divisor
		02
		03  LANG CoffeeScript
		04
		05  # I'm a comment!
		06
		07  gcd = (a, b) ->
		08  	[a, b] = [b, a % b] until b is 0
		09  	return a
		10
		11  input = prompt 'Enter a comma-delimited list of numbers'
		12
		13  list = input.split ','
		14
		15  result = list[0]
		16
		17  result = gcd result, i for i in list
		18
		19  alert "gcd(#{input}) = #{result}"
		20
		21  END

EXTENDED EXAMPLE

	Wikipedia gives the following example of a bookmarklet.  See here:
	https://en.wikipedia.org/wiki/Bookmarklet#Example.

		FILENAME: wiki-search.js

		01  javascript:(function(document) {
		02
		03  function se(d) {
		04  	return
		05  		d.selection ?
		06  		d.selection.createRange(1).text :
		07  		d.getSelection(1);
		08  };
		09
		10  let d = se(document);
		11
		12  for (
		13  	i = 0;
		14  	i < frames.length && (d == document || d == 'document');
		15  	i++
		16  )
		17  	d = se(frames[i].document);
		18
		19  if (d == 'document')
		20  	d = prompt('Enter%20search%20terms, '');
		21
		22  open('https://en.wikipedia.org' +
		23  	(d ? '/w/index.php?title=Special:Search&search=' +
		24  		encodeURIComponent(d) : '')).focus();
		25
		26  })(document);

	We can translate this into our language like this:

		FILENAME: wiki-search.bml

		01  BEGIN Wikipedia Searcher
		02
		03  ICON javascript.ico
		04  PARAMS document
		05  ARGS document
		06
		07  function se(d) {
		08  	return
		09  		d.selection ?
		10  		d.selection.createRange(1).text :
		11  		d.getSelection(1);
		12  };
		13
		14  let d = se(document);
		15
		16  for (
		17  	i = 0;
		18  	i < frames.length && (d == document || d == 'document');
		19  	i++
		20  )
		21  	d = se(frames[i].document);
		22
		23  if (d == 'document')
		24  	d = prompt('Enter%20search%20terms', '');
		25
		26  open('https://en.wikipedia.org' +
		27  	(d ? '/w/index.php?title=Special:Search&search=' +
		28  		encodeURIComponent(d) : '')).focus();
		29
		30  END

	We can package this into an importable file like this:

		perl bookmarklet-parser.pl wiki-search.bml > wiki-search.html

REMARK

	Notice that the IIFE is taken care of for us.  Its parameters and
	arguments are addressed with keywords.  Compare line 1 of wiki-search.js
	to line 4 of wiki-search.bml.  Additionally, compare line 26 of
	wiki-search.js to line 5 of wiki-search.bml.

	Also observe the ICON keyword on line three of wiki-search.bml.  Since
	bookmarklets are powered by JavaScript, I like to give them a JavaScript
	icon.  If you're on the command line, you might try this:

		wget https://raw.githubusercontent.com/
		edent/SuperTinyIcons/master/images/svg/javascript.svg

		convert -resize 16x16 javascript.svg javascript.ico

	But you can choose whatever icon you want.  Just provide the file path.

TODO

	Error handling needs addressed.

	I would like to add a FOLDER keyword that allows the user to specify a
	/path/like/this.  As of now, all the bookmarklets are placed in a single
	root folder called 'Bookmarklets.'  I would like to implement a tree
	data structure to accomplish folder nesting.  I'm new to Perl, so this
	is outside of my abilities at the moment.

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

my $user      = "";
my $anchors   = "";
my $href      = "";
my $icon      = "";
my $title     = "";
my $args      = "";
my $params    = "";
my $lang      = "";
my $sort_flag =  0;
my $root      = "Bookmarklets";


#  __
# (_    |_ .__   _|_o._  _  _
# __)|_||_)|(_)|_||_|| |(/__>

sub reset_vars {

	$href   = "";
	$icon   = "";
	$title  = "";
	$args   = "";
	$params = "";
	$lang   = "";
}

sub trim {

	my $str = shift;
	$str =~ s/^\s+|\s+$//g;
	return $str;
}

sub extract_content {

	# Extracts the content of an html element.

	return $1 if shift =~ m|>([^<]*)</|;

	# https://en.wikipedia.org/wiki/HTML_element#Syntax

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
}

sub encode_coffee { # shell dependency

	(my $coffee = shift) =~ s/"/\\"/g;

	my $cmd = "echo \"$coffee\" | coffee -csb ";

	open my $fh, '-|', $cmd or die $!;

	my $javascript = do { local $/; <$fh>};

	return "\n" . $javascript . "\n";

}

# The code inside the following subroutine, including comments, is entirely
# accredited to John Gruber, the inventor of Markdown.  It's his code, not mine.
# See the following links for more details.

	# https://en.wikipedia.org/wiki/John_Gruber
	# https://daringfireball.net/2007/03/javascript_bookmarklet_builder
	# https://gist.github.com/gruber/8658935

sub encode_js {

	my $javascript = shift;

	for ($javascript) {
		s{(^\s*//.+\n)}{}gm;        # Kill commented lines
		s{^\s*/\*.+?\*/\n?}{}gms;   # Kill block comments
		s{^\s+}{}gm;                # Kill line-leading whitespace
		s{\s+$}{}gm;                # Kill line-ending whitespace
		s{\n}{ }gm;                 # Kill newlines
		s{\t}{ }gm;                 # Tabs to spaces
		s{[ ]{2,}}{ }gm;            # Space runs to one space
	}

	# The order is important.

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

		$icon =
			' ICON="data:image/png;base64,' .
			encode_ico(trim $1) . '"';

	} elsif ($line =~ m/^LANG(.*)$/) {

		$lang = $1;

	} elsif ($line =~ m/^NAME(.*)$/) {

		next if $1 =~ m/^\s*$/;
		$user = trim($1) . "'s ";

	} elsif ($line =~ m/^SORT/) {

		$sort_flag = 1;

	} elsif ($line =~ m/^ROOT(.*)$/) {

		$root = trim $1;

	} elsif ($line =~ m/^BEGIN(.*)$/) {

		reset_vars();
		$title = trim $1;

	} elsif ($line =~ m/^END/) {

		$href = encode_coffee $href if $lang =~ m/CoffeeScript/i;

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

$anchors =
	join("\n",
		sort(
			{extract_content($a) cmp extract_content($b)}
			split("\n", $anchors)
		)
	) if $sort_flag;

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
    <DT><H3>${root}</H3>
    <DL><p>
$anchors
    </DL><p>
</DL>
EOF

print $document;
