
FILENAME: bookmarklets.txt
AUTHOR: Zachary Krepelka
DATE: Thursday, December 21st, 2023

DESCRIPTION

	Bookmarklets for the web browser.  This file can be packaged into an
	importable file using my bookmarklet-parsing Perl script.

################################################################################

NAME Zachary

BEGIN Favicon Grabber

ICON javascript.ico

/*
	This bookmarklet grabs the current website's favicon.

	See here for more information:

		https://dev.to/derlin/
		get-favicons-from-any-website-using-a-hidden-google-api-3p1e
*/

const url    = "http://www.google.com/s2/favicons?";
const domain = "domain=" + location.href;
const size   = "&sz=" + prompt("What size?", "16");

location.href = url + domain + size;

END

################################################################################

BEGIN Greatest Common Divisor

LANG CoffeeScript
ICON javascript.ico

gcd = (a, b) ->
	[a, b] = [b, a % b] until b is 0
	return a

input = prompt 'Enter a comma-delimited list of numbers'

list = input.split ','

result = list[0]

result = gcd result, i for i in list

alert "gcd(#{input}) = #{result}"

END

################################################################################

BEGIN Google Chrome Extension List

ICON javascript.ico

/*
	This bookmarklet helps the user generate a list of installed Google
	Chrome extensions for safekeeping.  I adapted the code from an answer on
	Super User into a bookmarklet for ease of use.  See here:

		https://superuser.com/a/1691722

	The process involves accessing chrome://extensions.  JavaScript usage is
	restricted on Chrome webpages, e.g., chrome://path, so some effort is
	required on the part of the user.  A help page is provided.
*/

const code =
	"console.log("                                     +
	"document.querySelector('extensions-manager')."    +
	"extensions_.map(({id, name, state, webStoreUrl})" +
	" => (name)).join('\\n'));"                        ;

const content = `
<html>
	<body>
		<h1>Google Chrome Extension List</h1>

		<p>
			This tool helps you generate a list of installed Google
			Chrome extensions for safekeeping.
		</p>

		<h2>Instructions</h2>

		<p> User intervention is required.

			<ol>
				<li>Open <code>chrome://extensions</code>.</li>
				<li>Press <kbd>F12</kbd> & click 'Console'.</li>
				<li>Paste your clipboard.</li>
				<li>Press <kbd>Enter</kbd>.</li>
			</ol>

		</p>

		<h2>Clipboard</h2>

		<p>
			It should look like this: <br><br>
			<code>${code}</code>
		</p>
	</body>
</html>`;

// Comment this line out if you know what you're doing.
window.open().document.write(content);

navigator.clipboard.writeText(code);

END

UPDATED: Monday, January 8th, 2024   6:10 PM
