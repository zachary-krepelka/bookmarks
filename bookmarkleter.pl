#!/usr/bin/env perl

# FILENAME: bookmarkleter.pl
# AUTHOR: Zachary Krepelka
# DATE: Friday, January 5th, 2024
# ABOUT: a bookmarklet compiler for the command line
# ORIGIN: https://github.com/zachary-krepelka/bookmarks
# UPDATED: Wednesday, June 5th, 2024 at 1:56 AM

################################################################################

#
# |\/| _  _|   | _  _
# |  |(_)(_||_||(/__>

use strict;
use warnings;
use feature qw(say);
use File::Basename;                  # https://metacpan.org/pod/File::Basename
use Getopt::Long;                    # https://perldoc.perl.org/Getopt::Long
use MIME::Base64 qw(encode_base64);  # https://metacpan.org/pod/MIME::Base64
use URI::Escape qw(uri_escape_utf8); # https://metacpan.org/pod/URI::Escape

# For Debugging
# use Data::Dump qw(dump);

################################################################################

# \  /_.._o _.|_ | _  _
#  \/(_|| |(_||_)|(/__>

GetOptions(
	'ugly' => \my $outsourced,
	'help' => \my $help_flag
);

my $bookmarklets = {};
my $href         = "";
my $icon         = "";
my $name         = "";
my $path         = "";
my $args         = "";
my $params       = "";
my $lang         = "";
my $root         = "Bookmarklets";

#--------------------------------------------------#

my $bookmarks = 'zya3aiGae';

# This string variable serves as a default hash key.
# Its contents don't matter but would preferably be
# something nonsensical.  It should start with the
# letter z for sorting reasons. (Made with pwgen.)

#--------------------------------------------------#

################################################################################

#  __
# (_    |_ .__   _|_o._  _  _
# __)|_||_)|(_)|_||_|| |(/__>

sub usage {

	my $program = basename($0);
	print STDERR <<~USAGE;
		Usage: $program [options] <file>
		a bookmarklet compiler for the command line

		Example:
		  perl $program source-code.txt > bookmarklets.html

		    * source-code.txt wraps js code in a custom file format
		    * bookmarklets.html imports into a web browser
		    * read documentation for detailed usage

		Options:
		  -u, --ugly	outsource compression to UglifyJS
		  -h, --help	display this help message

		Documentation: perldoc $program
		USAGE
	exit;
}

sub reset_vars {

	$href   = "";
	$icon   = "";
	$args   = "";
	$params = "";
	$lang   = "";
}

sub trim {

	my $str = shift;
	$str =~ s/^\s+|\s+$//g;
	return $str;
}

sub encode_js_internally {

	# Taken from John Gruber's blog with slight modification.

	# https://en.wikipedia.org/wiki/John_Gruber
	# https://daringfireball.net/2007/03/javascript_bookmarklet_builder
	# https://gist.github.com/gruber/8658935

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

	return uri_escape_utf8($javascript);
}

sub encode_js_externally { # introduces a shell dependency

	(my $javascript = shift) =~ s/'/'"'"'/g;

	return uri_escape_utf8(`echo '$javascript' | uglifyjs -c -m`);
}

sub encode_coffee {        # introduces a shell dependency

	(my $coffeescript= shift) =~ s/'/'"'"'/g;

	return `echo '$coffeescript' | coffee -csb`;
}

	# The credit for the algorithm in the following
	# function goes to a Stack Overflow post.  The
	# algorithm was originally presented in Python.
	# I translated it into Perl and adapted it for
	# my needs.

		# https://stackoverflow.com/q/8484943

sub attach {

	my ($tree, $path, $url, $icon) = @_;

	my @parts = split /\//, $path, 2;

	if (@parts == 1) {

		my $name = shift @parts;

		push @{$tree->{$bookmarks}}, [ $name, $url, $icon ];

	} else {

		my ($folder, $rest) = @parts;

		if (defined $folder) {

			if (not grep { $_ eq $folder } keys %$tree) {

				$tree->{$folder} = { $bookmarks => [] };

			}

			attach($tree->{$folder}, $rest, $url, $icon);
		}
	}
}

sub encode_ico {

	open (IMAGE, shift) || return ""; # fails silently

	return encode_base64( do { local $/ = undef; <IMAGE>; }, '');
}

sub bookmark_builder {

	my $bookmark = shift;

	my ($name, $href, $icon) = @$bookmark;

	no warnings 'uninitialized';

	$href = " HREF=\"$href\"";

	$icon = encode_ico $icon if $icon;

	$icon = " ICON=\"data:image/png;base64,$icon\"" if $icon;

	return "<DT><A$href$icon>$name</A>";
}

sub helper {

	my ($tree, $depth) = @_;

	my $pad = (" " x 4) x $depth;

	foreach my $key (sort keys %$tree) {

		my $value = %$tree{$key};

		if ($key eq $bookmarks) {

			for my $bookmark (sort {@$a[0] cmp @$b[0]} @$value) {

				say $pad . bookmark_builder $bookmark;
			}

		} else {

			say "$pad<DT><H3>$key</H3>";
			say "$pad<DL><p>";

			helper($value, $depth + 1);

			say "$pad</DL><p>";
		}
	}
}

sub bookmarkify {

my $tree = shift;

print <<"EOF";
<!DOCTYPE NETSCAPE-Bookmark-file-1>

<!--
	 ___           _                  _   _     _
	| _ ) ___  ___| |___ __  __ _ _ _| |_| |___| |_ ___
	| _ \\/ _ \\/ _ \\ / / '  \\/ _` | '_| / / / -_)  _(_-<
	|___/\\___/\\___/_\\_\\_|_|_\\__,_|_| |_\\_\\_\\___|\\__/__/

	This file was generated with a Perl script written by Zachary Krepelka.

		https://github.com/zachary-krepelka/bookmarks.git
-->

<TITLE>Bookmarks</TITLE>
<H1>Bookmarks</H1>
<DL><p>
    <DT><H3>$root</H3>
    <DL><p>
EOF

helper($tree, 2);

print <<'EOF';
    </DL><p>
</DL><p>
EOF
}

################################################################################

#  _         _                   _
# /  _ .__  |_).__  _ .__.._ _  |_  ._  __|_o _ ._  _.|o_|_
# \_(_)|(/_ |  |(_)(_||(_|| | | ||_|| |(_ |_|(_)| |(_||| |_\/
#                   _|                                     /

usage if $help_flag;

my $encode_js = $outsourced ? \&encode_js_externally : \&encode_js_internally;

while (my $line = <>) {

	   if( $line =~ /^ARGS(.*)$/   ) { $args   = trim $1;                }
	elsif( $line =~ /^PARAMS(.*)$/ ) { $params = trim $1;                }
	elsif( $line =~ /^ICON(.*)$/   ) { $icon   = trim $1;                }
	elsif( $line =~ /^LANG(.*)$/   ) { $lang   = trim $1;                }
	elsif( $line =~ /^ROOT(.*)$/   ) { $root   = trim $1;                }
	elsif( $line =~ /^FOLDER(.*)$/ ) { $path   = trim($1) . '/' . $name; }
	elsif( $line =~ /^BEGIN(.*)$/  ) {

		reset_vars();
		$name = trim $1;
		$path = $name;

	} elsif ($line =~ m/^END/) {

		$href = encode_coffee $href if $lang =~ m/CoffeeScript/i;

		$href = 'javascript:' . &$encode_js(

			'(function(' .
			$params      .
			'){'         .
			$href        .
			'})('        .
			$args        .
			');'        );

		attach($bookmarklets, $path, $href, $icon);

	} else {

		$href .= $line;

	}
}

bookmarkify $bookmarklets;

__END__

################################################################################

#  _
# | \ _  _   ._ _  _ .__|_ _._|_o _ ._
# |_/(_)(_|_|| | |(/_| ||_(_| |_|(_)| |

=head1 NAME

bookmarkleter - a bookmarklet compiler for the command line

=head1 SYNOPSIS

Below I describe the program's input, output, and usage.

=head2 Usage

perl  bookmarkleter.pl  [OPTIONS]  <SOURCE CODE FILE>  >  [BOOKMARK FILE]

=head2 Input

The input is a file which holds the source code for one or more bookmarklets,
preferably having the .bml extension.  This extension denotes my custom file
format, which I describe in the section of this document titled 'file format
specification.' It is a wrapper around JavaScript and other languages that
transpile to JavaScript.

=head2 Output

The output is a file in the Netscape Bookmark file format.  This file format was
originally created to store bookmarks for the Netscape web browser.  All major
web browsers today use this standard to import and export bookmarks.  These
files have the html extension with the HTML document type declaration

	<!DOCTYPE NETSCAPE-Bookmark-file-1>.

=head1 DESCRIPTION

This script is a bookmarklet compiler.  First and foremost, what is a
bookmarklet?  Quoting bookmarklets.org, a bookmarklet is "a special kind of
[digital, web-browser] bookmark that performs a task when you click it.
Bookmarklets are tiny programs stored inside bookmarks....A bookmarklet is
usually written in the programming language called JavaScript," the programming
language of the web.

The purpose of this script is to compile source code for bookmarklets into a
file that one can import into a web browser.  Namely, it packages JavaScript
Code into a Netscape bookmark file containing bookmarklets.  This allows the
user to store bookmarklet source code in a readable format while still having
the ability to quickly 'compile' the code into an importable file.

=head1 OPTIONS

=over

=item B<-u>, B<--ugly>

Compress and mangle the code using the UglifyJS command-line tool.  An internal
method will be used if absent.  Using this flag will result in a smaller file.
The idea is to outsource the work to a program that does a better job.  There is
only a dependency when the flag is used.

=item B<-h>, B<--help>

Display a help message and exit.

=back

=head1 MOTIVATIONS

A bookmarklet is a bookmark that contains JavaScript code.  When the bookmark is
opened, its code is executed.  Bookmarklets provide small units of functionality
to the web browser.

The typical way of creating a bookmarklet entails copy-and-pasting JavaScript
code into the URL box when adding or editing a bookmark.  Internally, the
JavaScript code is stored entirely within the HREF attribute of an HTML anchor.
Accordingly, the browser automatically compresses your code into a single line.
It also translates HTML-invalid characters.

Bottom line, the code becomes unreadable.  This mandates storing your
bookmarklet code in a readable format as a backup.  For copy-and-pasting
convenience, many people share their bookmarklet code in a one-line format.  But
there's a problem.  Can anyone tell me what this does at first glance?

	javascript:(function(document){function se(d){return d.selection
	?d.selection.createRange(1).text:d.getSelection(1);};letd=se(doc
	ument);for(i=0;i<frames.length&&(d==document||d=='document');i++
	)d=se(frames[i].document);if(d=='document')d=prompt('Enter%20sea
	rch%20terms%20for%20Wikipedia','');open('https://en.wikipedia.or
	g'+(d?'/w/index.php?title=Special:Search&search='+encodeURICompo
	nent(d):'')).focus();})(document);

Readability is a must, but copy-and-pasting is tedious.  Comments have to be
removed.  Characters that break HTML encoding can pose problems.  Many online
tools exist to help with these issues, but none of them suited my needs.

I wanted a tool that

=over

=item * promotes source code readability.

=item * packages bookmarklets in bulk.

=item * works from the command line.

=back

I wrote this script to suit my needs.

=head1 FILE FORMAT SPECIFICATION

The input file should adhere to this file format specification.

The file consists of blocks delimited by BEGIN and END.  The delimiters are
placed at the beginning of a new line.  The blocks are *not* nested.  Each block
contains valid JavaScript code constituting one bookmarklet.

The following are keywords if placed at the beginning of a new line:

	---------------------------------------------------------
	KEYWORD     ARGUMENTS                SCOPE      CONDITION
	---------------------------------------------------------
	BEGIN       bookmark name            n/a        required
	END         n/a                      n/a        required
	ICON        local filepath           local      optional
	FOLDER      path to bookmark         local      optional
	LANG        programming language     local      optional
	ARGS        comma-delimited list     local      optional
	PARAMS      comma-delimited list     local      optional
	ROOT        folder name              global     optional
	---------------------------------------------------------

The keywords with local scope should optionally appear inside of the blocks
delimited by BEGIN and END.  They pertain to individual bookmarklets.  The
keywords with global scope can appear anywhere.  They pertain to the resulting
file as a whole.  The only required keywords are the BEGIN and END delimiters
themselves.

Let's walk though each keyword individually to understand its purpose.  Many of
the keywords accept arguments, which are placed directly after the keyword on
the same line with a space in between.

=head2 Begin

The argument passed to BEGIN is the title of the bookmarklet.  It will appear as
the name of the bookmark when imported into a web browser.  Everything after the
keyword up until the end of the line is eaten up.

=head2 Icon

The ICON keyword expects the file path of an icon stored on the local machine.
This will become the favicon of the bookmark when imported into a web browser.
Everything after the keyword up until the end of the line is eaten up.  Please
only specify one file with the .ico extension.

=head2 Folder

The FOLDER keyword allows the user to specify a bookmarklet's location in the
imported folder structure by providing a path/like/this/one.  If absent, the
bookmark will appear in the root imported folder.  The path is to a folder;
don't include the name of the bookmark.

=head2 Lang

The LANG keyword allows a programmer to write bookmarklets in languages other
than JavaScript, namely in languages that I<transpile> to JavaScript.
Currently, the LANG keyword only knows one message, and that's 'CoffeeScript.'
In the future, support for other languages will be added.  This keyword calls on
external programs to transpile code, so make sure the required tools are
installed on your system.  (See the DEPENDENCIES section).

=head2 Params & Args

Everything within a block is automatically wrapped in an immediately invoked
function expression.  The keywords PARAMS and ARGS pertain to this detail.  An
IIFE for short looks like this:

	(function () { /* ... */ })();

Sometimes it's useful to specify parameters and pass arguments.

	(function (document) { /* ... */ })(document);

That's what PARAMS and ARGS do.  Recall the difference between parameters and
arguments: arguments are values passed into function calls whereas parameters
are variables declared in a function's definition.  Arguments are bound to
parameters when a function enters into scope.

=head2 Root

The ROOT keyword's argument is the name of the root folder containing the
bookmarklets. If the ROOT keyword is unspecified, the name will default to
'Bookmarklets.'

=head1 EXAMPLES

=head2 Minimal Working Example

Create a file on your computer with the following contents.  Make sure it's in
the same directory as this script.  You might name it something like
'hello-world.js,' but since our file format isn't truly valid JavaScript, you
might consider making up your own file extension like '.bml' for
[b]ook[m]ark[l]et.  You can put as many bookmarklets as you want in a .bml file,
but let's stick to just one for now.

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

	perl bookmarkleter.pl hello-world.bml > bookmarklets.html

The last step is to import 'bookmarklets.html' into your web browser.

=head2 Another Example

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

=head2 Extended Example

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

	perl bookmarkleter.pl wiki-search.bml > wiki-search.html

=head2 Remark

Notice that the IIFE is taken care of for us.  Its parameters and arguments are
addressed with keywords.  Compare line 1 of wiki-search.js to line 4 of
wiki-search.bml.  Additionally, compare line 26 of wiki-search.js to line 5 of
wiki-search.bml.

Also observe the ICON keyword on line three of wiki-search.bml.  Since
bookmarklets are powered by JavaScript, I like to give them a JavaScript icon.
If you're on the command line, you might try this:

	wget https://raw.githubusercontent.com/
	edent/SuperTinyIcons/master/images/svg/javascript.svg

	convert -resize 16x16 javascript.svg javascript.ico

But you can choose whatever icon you want.  Just provide the file path.

=head1 VIM SYNTAX HIGHLIGHTING

Below is a Vimscript for syntax highlighting of the file format described in
this document. Put it in ~/.vim/syntax and use it with :set syntax=bookmarklet.

	01  " FILENAME: bookmarklet.vim
	02  " AUTHOR: Zachary Krepelka
	03  " DATE: Friday, March 22nd, 2024
	04  " ABOUT: a syntax highlighting file
	05
	06  let s:keywords =
	07  \[
	08  	\ 'ARGS',
	09  	\ 'BEGIN',
	10  	\ 'END',
	11  	\ 'FOLDER',
	12  	\ 'ICON',
	13  	\ 'LANG',
	14  	\ 'PARAMS',
	15  	\ 'ROOT'
	16  \]
	17
	18  let s:argument_accepting_keywords =
	19  \[
	20  	\ 'ARGS',
	21  	\ 'BEGIN',
	22  	\ 'FOLDER',
	23  	\ 'ICON',
	24  	\ 'LANG',
	25  	\ 'PARAMS',
	26  	\ 'ROOT'
	27  \]
	28
	29  execute 'syntax match bookmarkletKeyword'
	30  \ '"^\('..join(s:keywords,'\|')..'\)"'
	31
	32  execute 'syntax match bookmarkletKeywordArgument'
	33  \ '"\(^\('..join(s:argument_accepting_keywords,'\|')..'\)\)\@<=.*"'
	34
	35  highlight  link  bookmarkletKeyword          Keyword
	36  highlight  link  bookmarkletKeywordArgument  String

=head1 DEPENDENCIES

The following software should be installed on your system.  These software
dependencies are not strictly necessary, but not all features will be available
without them.

=over

=item * Node.js L<https://nodejs.org/en>

=item * npm L<https://www.npmjs.com/>

=item * UglifyJS L<https://www.npmjs.com/package/uglify-js>

=item * CoffeeScript L<https://coffeescript.org/#installation>

=back

If you're on Ubuntu, you might try the following commands:

	sudo apt-get install nodejs npm
	sudo npm install --global uglify-js
	sudo npm install --global coffeescript

=head1 SEE ALSO

This script is part of my GitHub repository.

	https://github.com/zachary-krepelka/bookmarks.git

This repository contains various scripts for bookmark management.

=head1 AUTHOR

Zachary Krepelka L<https://github.com/zachary-krepelka>

=cut

#
