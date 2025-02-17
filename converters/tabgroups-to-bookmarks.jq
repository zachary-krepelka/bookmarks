#!/usr/bin/env -S jq -rf

# FILENAME: tabgroups-to-bookmarks.jq
# AUTHOR: Zachary Krepelka
# DATE: Sunday, February 16th, 2025
# ABOUT: Tab Groups Extension data converter
# ORIGIN: https://github.com/zachary-krepelka/bookmarks.git

"<!DOCTYPE NETSCAPE-Bookmark-file-1>
<!--
	This file was generated with a script written by Zachary Krepelka.

		https://github.com/zachary-krepelka/bookmarks.git
-->
<TITLE>Bookmarks</TITLE>
<H1>Bookmarks</H1>
<DL><p>
    <DT><H3>Tab Groups</H3>
    <DL><p>",

([.[]][0:-1][] |

      " " * 8
    + "<DT><H3 ADD_DATE=\"\(.createTime)\">"
    + @html "\(.title)"
    + "</H3>\n"
    + " " * 8
    + "<DL><p>",

    (.tabs[] |

          " " * 12
        + "<DT><A HREF=\"\(.url)\""
        + (
            if has("favIconUrl")
            then
                " ICON_URI=\"\(.favIconUrl)\""
            else
                ""
            end
        )
        + ">"
        + @html "\(.title)"
        + "</A>"

    ),

    " " * 8 + "</DL><p>"

),

"    </DL><p>
</DL><p>"

# =pod
#
# =head1 NAME
#
# tabgroups-to-bookmarks.jq - Tab Group Data to Bookmark File Converter
#
# =head1 SYNOPSIS
#
# =head2 Usage
#
#  jq -rf tabgroups-to-bookmarks.jq tabgroups_data.json > bookmarks.html
#
# =head2 Documentation
#
#  sed -n '/^# =pod/,/^# =cut/{s/^# \?//;p}' tabgroups-to-bookmarks.jq | pod2text
#  sed -n '/^# =pod/,/^# =cut/{s/^# \?//;p}' tabgroups-to-bookmarks.jq | pod2html | lynx -stdin
#
# =head1 DESCRIPTION
#
# This script targets a browser extension.  The I<Tab Groups Extension> is a web
# browser add-on developed by Guokai Han for Google Chrome and Microsoft Edge.
# It is used to "automatically group tabs, save tabs/groups, and provide
# shortcuts for tabs/groups".  The extension allows the user to import and
# export saved groups of tabs to a JSON file called
#  C<tabgroups_data_YYYYMMDD.json>.
#
# The purpose of this script is to convert these JSON files into the Netscape
# bookmark file format so that can be imported into a web browser natively.
#
# You can find the extension this script targets at L<https://guokai.dev/>.
# Find the extension's author's GitHub at L<https://github.com/hanguokai>.
#
# =over
#
# =item Edge
#
# L<https://chromewebstore.google.com/detail/tab-groups-extension/nplimhmoanghlebhdiboeellhgmgommi>
#
# =item Chrome
#
# L<https://microsoftedge.microsoft.com/addons/detail/tab-groups-extension/jgcmbjdhakghmngjkdpejdcchbigdmgf>
#
# =back
#
# =head1 SEE ALSO
#
# This script is part of my GitHub repository.
#
# 	https://github.com/zachary-krepelka/bookmarks.git
#
# This repository contains various scripts for bookmark management.
#
# =head1 AUTHOR
#
# Zachary Krepelka L<https://github.com/zachary-krepelka>
#
# =cut
