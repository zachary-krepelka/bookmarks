#!/usr/bin/env perl

# FILENAME: treeifier.pl
# AUTHOR: Zachary Krepelka
# DATE: Friday, March 29th, 2024
# ABOUT: treeify a bookmark file

use strict;
use warnings;
use File::Basename;

if ($ARGV[0] eq '-h' || $ARGV[0] eq '--help')
{
	my $prog = basename($0);
	print STDERR <<~USAGE;
		Usage: $prog [options] <file>
		treeify a bookmark file

		Documentation: perldoc $prog
		Options:       -h to display this help message
		Example:       perl $prog bookmarks.html > tree-view.html
		USAGE
	exit;
}

print <<'EOF';
<!DOCTYPE html>

<!--
	 _                      ___
	|_) _  _ | ._ _  _.._|   |.__  _  \  /o _
	|_)(_)(_)|<| | |(_|| |<  ||(/_(/_  \/ |(/_\/\/

	This file was generated with a Perl script written by Zachary Krepelka.

		https://github.com/zachary-krepelka/bookmarks.git
-->

<html>
<head>
<style>
ul, #tree {
	list-style-type: none;
}

#tree {
	margin: 0;
	padding: 0;
}

.folder {
	cursor: pointer;
	-webkit-user-select: none;
	-moz-user-select: none;
	-ms-user-select: none;
	user-select: none;
}

.folder::before {
	content: "\25B6";
	color: black;
	display: inline-block;
	margin-right: 6px;
}

.opened-folder::before {
	-ms-transform: rotate(90deg);
	-webkit-transform: rotate(90deg);'
		transform: rotate(90deg);
}

.contents {
	display: none;
}

.active {
	display: block;
}

a {
	text-decoration: none;
	color: #000;
}
</style>
</head>
<body>

<!-- USER-GENERATED CONTENT BEGINS HERE --------------------------------------->

<ul id="tree">
    <li><span class="folder">Root</span>
EOF

while (<>) {

	next if $. <= 9;

	s|<DT><H3.*?>(.*)</H3>|<li><span class="folder">$1</span>|;
	s|<DL><p>|<ul class="contents">|;
	s|<DT><A HREF="(.*?)".*?>(.*)</A>|<li><a href="$1">$2</a></li>|;
	s|</DL><p>|</ul></li>|;

	print;
}

print <<'EOF';
</ul>

<!-- USER-GENERATED CONTENT ENDS HERE ----------------------------------------->

<script>
var i, toggler = document.getElementsByClassName("folder");

for (i = 0; i < toggler.length; i++) {

	toggler[i].addEventListener("click", function() {

		this
		.parentElement
		.querySelector(".contents")
		.classList
		.toggle("active");

		this.classList.toggle("opened-folder");

});}
</script>
</body>
</html>
EOF

__END__

=head1 NAME

treeifier.pl - treeify a bookmark file

=head1 SYNOPSIS

Below I describe the program's input, output, and usage.

=head2 Usage

perl treeifier.pl [bookmark file] > [html file]

=head2 Input

The input is a file in the Netscape Bookmark file format.

=head2 Output

The output is a standard HTML file.

=head1 DESCRIPTION

The purpose of this script is to transform a Netscape bookmark file into an
expandable and collapsible tree view.  The Netscape bookmark file is usually
utilized to transfer bookmarks between web browsers via importing and exporting,
but it can also be opened directly as an html file.  However, it displays all
the file contents at once, presumably for printing.  This is unintuitive for
interactive data exploration.  A tree view would be better.  This script takes a
Netscape bookmark file and produces an html file facilitating a tree view with
clickable links and folders.

=head1 CAVEATS

Only tested with Google Chrome.

=head1 NOTES

The generated HTML, CSS, and JavaScript are based on this tutorial.

	https://www.w3schools.com/howto/howto_js_treeview.asp

=head1 SEE ALSO

This script is part of my GitHub repository.

	https://github.com/zachary-krepelka/bookmarks.git

This repository contains various scripts for bookmark management.

=head1 AUTHOR

Zachary Krepelka L<https://github.com/zachary-krepelka>

=cut

#
