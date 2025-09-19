#!/usr/bin/sed -f

# FILENAME: tree.sed
# AUTHOR: Zachary Krepelka
# DATE: Saturday, May 17th, 2025
# ABOUT: for including file tree diagrams in readme files
# ORIGIN: https://github.com/zachary-krepelka/bookmarks.git
# UPDATED: Sunday, June 1st, 2025 at 10:43 PM

/^```graphql$/,/^```$/{

	/^```$/etree -F --info --noreport --charset=ascii -I sed* -I tree.sed | tr '[' '#'

	/^```/p

	d
}

# Explanation of shell command

# tree                to create an ASCII art digram of the directory structure
#     -F              to emphasize the distinction between files and folders
#     --info          to document the file structure
#     --noreport      because the number of files and directories is irrelevant
#     --charset=ascii because smaller character sets are suckless
#     -I sed*         to ignore GNU sed's temporary files
#     -I tree.sed     to ignore this file itself
#  tr [ #             because the hash is a GraphQL comment

# =pod
#
# =head1 NAME
#
# tree.sed - include file tree diagrams in readme files
#
# =head1 SYNOPSIS
#
# =head2 Usage
#
#  sed -i -f tree.sed README.md
#  sed    -f tree.sed README.md | sponge README.md
#
# =head2 Documentation
#
#  sed -n '/^# =pod/,/^# =cut/{s/^# \?//;p}' tree.sed | pod2text
#  sed -n '/^# =pod/,/^# =cut/{s/^# \?//;p}' tree.sed | pod2html | lynx -stdin
#
# =head1 DESCRIPTION
#
# The purpose of this script is to update file tree diagrams in GitHub-flavored
# markdown files.
#
# =head2 Background
#
# It is sometimes helpful to include a diagram of a project's directory
# structure in a README file.  Doing so provides an overview of the project.
# This is typically achieved using the GNU/Linux C<tree> command.
#
# 	tree >> readme.txt
#
# Beyond merely providing an overview, this is useful for documenting a project
# more generally.  When invoked with the --info flag, the tree command displays
# comments under each file and directory as read from a .info file.   This can
# be used to provide a brief synopsis of each file and directory.
#
# 	tree --info >> readme.txt
#
# In GitHub-flavored markdown files, the tree diagram must be enclosed in a
# fenced code block, as indicated below.
#
#         ```text
#         ./
#         |-- HELP.md
#         |-- build.gradle
#         |-- gradle/
#         |   `-- wrapper/
#         |       |-- gradle-wrapper.jar
#         |       `-- gradle-wrapper.properties
#         |-- gradlew*
#         |-- gradlew.bat
#         |-- settings.gradle
#         `-- src/
#             |-- main/
#             |   |-- java/
#             |   |   `-- com/
#             |   |       `-- example/
#             |   |           `-- demo/
#             |   |               `-- DemoApplication.java
#             |   `-- resources/
#             |       |-- application.properties
#             |       |-- static/
#             |       `-- templates/
#             `-- test/
#                 `-- java/
#                     `-- com/
#                         `-- example/
#                             `-- demo/
#                                 `-- DemoApplicationTests.java
#         ```
#
# When rendered online, GitHub's fenced code blocks are syntax highlighted
# according to the keyword succeeding the three opening backticks. To disable
# syntax highlighting altogether, the keyword C<text> can be used.
#
# While there is no dedicated grammar for syntax highlighting tree diagrams, one
# tip I found online is to use the C<graphql> keyword.  Quoting
# L<https://github.com/DavidWells/advanced-markdown>:
#
#  	For whatever reason the graphql
#  	syntax will nicely highlight
#  	file trees.
#
# Hence, your README.md could contain the following.
#
# 	```graphql
# 	TREE DIAGRAM HERE
# 	```
#
# =head2 Problem
#
# An annoyance with this idea is that for living projects that are still
# evolving, the readme file will need updated as the directory structure
# changes.  It is not enough to type
#
# 	tree >> README.md
#
# because
#
# =over
#
# =item * the previous diagram needs to be deleted,
#
# =item * the new diagram must be enclosed in a fenced code block,
#
# =item * the diagram may not be positioned at the end of the file.
#
# =back
#
# Additional, interactive editing is required.  This is a cumbersome process
# implicated with every change to the directory structure.
#
# =head2 Solution
#
# The goal of this script is to automate this process.  Instead of manually
# updating the README's file tree diagram every time new files are added or
# removed, it suffices just to type
#
# 	sed -i -f tree.sed README.md
#
# =head2 Getting Started
#
# To use this script with your project, follow these steps.
#
# =over
#
# =item Step 1
#
# Create a README.md file in the root directory of your project if it does not
# already exist.
#
# =item Step 2
#
# This script makes use of the graphql trick described earlier.  Edit the
# README.md file to contain the following lines at the location where you want
# the file tree diagram to appear.
#
# 	```graphql
# 	```
#
# =item Step 3
#
# Create a .info file in the root directory of your project to document your
# file structure.  This step is optional.  To get started, you can use the
# following command line.
#
# 	find . -mindepth 1 -not -path '*/.*' | sed 's/$/\n\tTODO/' > .info
#
# Your job is to replace each TODO in the resulting file with a preferably
# one-line synopsis of the file or folder that it is intended to describe.  You
# can read more about .info files in the tree command's man page.  See also:
# L<https://unix.stackexchange.com/q/697245>.
#
# =item Step 4
#
# Invoke this script on the README file from within the same directory to inject
# an ASCII art file tree diagram. This can be done in place using the C<-i>
# flag, assuming the GNU implementation of sed is used. A second option is to
# use the C<sponge> command from C<moreutils> to circumvent the use of a
# temporary file.
#
# =back
#
# =head1 EXAMPLE
#
# The following bash script demonstrates the usage of this script.
#
# 	01 #!/bin/bash
# 	02
# 	03 mkdir demo
# 	04
# 	05 cp tree.sed ./demo
# 	06
# 	07 cd demo
# 	08
# 	09 # generate an example file structure
# 	10
# 	11 mkdir dir{1..3}
# 	12
# 	13 for dir in dir{1..3}
# 	14 do touch $dir/file{1..3}.txt
# 	15 done
# 	16
# 	17 # create a readme file
# 	18
# 	19 cat <<'EOF' > README.md
# 	20 # Dummy Project
# 	21
# 	22 A description of the project.
# 	23
# 	24 ## File Structure
# 	25
# 	26 ```graphql
# 	27 ```
# 	28
# 	29 ## Another Section
# 	30
# 	31 The tree diagram can be located
# 	32 anywhere in the readme file,
# 	33 such as in the middle.
# 	34 EOF
# 	35
# 	36 # create a .info file
# 	37
# 	38 find . -mindepth 1 -not -path '*/.*' |
# 	39 sed 's/$/\n\tDescription Here/' > .info
# 	40
# 	41 # invoke the script on the readme file
# 	42
# 	43 sed -i -f tree.sed README.md
#
# The README file will be updated to contain a file tree of the project inside
# of the fenced code block.
#
# =head1 AUTHOR
#
# Zachary Krepelka L<https://github.com/zachary-krepelka>
#
# =cut
