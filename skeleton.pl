#!/usr/bin/env perl

# FILENAME: skeleton.pl
# AUTHOR: Zachary Krepelka
# DATE: Thursday, June 6th, 2024
# ABOUT: strips bookmarks leaving only folders
# ORIGIN: https://github.com/zachary-krepelka/bookmarks.git

while (<>) { print unless /<A/; } # That's all!

__END__

=head1 NAME

skeleton.pl - strip bookmarks leaving only folders

=head1 SYNOPSIS

perl skeleton.pl {bookmark file} > {stripped down bookmark file}

=head1 DESCRIPTION

This script operates on the Netscape bookmark file format.  It strips out all
the bookmarks from the file, leaving only a folder structure.  To use this
script:

=over

=item 1 Export your bookmarks from your web browser.

=item 2 Run this script on that file.

=item 3 The output is an importable bookmark file.

=back

=head1 USE CASE

You maintain different bookmarks for work and personal life, but want to have a
consistent folder structure. You can extract the folder structure with this
script without carrying over the bookmarks.

=head1 SEE ALSO

This script is part of my GitHub repository.

	https://github.com/zachary-krepelka/bookmarks.git

This repository contains various scripts for bookmark management.

=head1 AUTHOR

Zachary Krepelka L<https://github.com/zachary-krepelka>

=cut

#
