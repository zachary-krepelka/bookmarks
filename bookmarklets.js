// FILENAME: bookmarklets.js
// AUTHOR: Zachary Krepelka
// DATE: Thursday, December 21st, 2023
// ABOUT: bookmarklets for the web browser
// ORIGIN: https://github.com/zachary-krepelka/bookmarks.git
// UPDATED: Friday, April 26th, 2024 at 2:17 AM

################################################################################

         /* This source code can be packaged into an importable file */
         /* using my bookmarklet-parsing Perl script.  Find it in my */
         /* GitHub repository as stated above.  The words in all     */
         /* caps are keywords recognized by the parser.              */

################################################################################

NAME Zachary

SORT

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

/* This bookmarklet helps the user generate a list of installed Google Chrome
 * extensions for safekeeping.  I adapted the code from an answer on Super User
 * into a bookmarklet for ease of use.  See here:
 *
 * 	https://superuser.com/a/1691722
 *
 * The process involves accessing chrome://extensions.  JavaScript usage is
 * restricted on Chrome webpages, e.g., chrome://path, so some effort is
 * required on the part of the user.  A help page is provided.
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
			This tool helps the user generate a list of installed
			Google Chrome extensions for safekeeping.
		</p>

		<h2>Instructions</h2>

		<p> User intervention is required.

			<ol>
				<li>Open <code>chrome://extensions</code>.</li>
				<li>Press <kbd>F12</kbd> & click 'Console'.</li>
				<li>Type 'allow pasting'.</li>
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

################################################################################

BEGIN Center Page

ICON javascript.ico

/* Today I was reading this web page:
 *
 * 	https://norvig.com/lispy.html
 *
 * It frustrated me that the page was uncentered.
 * I found two solutions on Stack Overflow:
 *
 * 	https://stackoverflow.com/q/15505225
 * 	https://stackoverflow.com/q/6464592
 *
 * I am combining them into a bookmarklet.
 */

function addStyle(styleString) {
	const style = document.createElement('style');
	style.textContent = styleString;
	document.head.append(style);
}

addStyle(`
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
`);

END

################################################################################

BEGIN com2net

ICON javascript.ico

location.href = location.href.replace(/com/, 'net');

END Monday, February 5th, 2024 at 8:49 PM

################################################################################

BEGIN YouTube Playlist Plucker

ICON javascript.ico

/* When listening to playlists on YouTube, I often find songs that I like and
 * consequently want to save with a bookmark.  However, I want to save the song
 * independently of the playlist that I found it in.  I created this bookmarklet
 * for this reason.
 *
 * The purpose of this bookmarklet is to detether a YouTube video from a
 * playlist.  It redirects a YouTube video that is part of a playlist to the
 * page having that video by itself.
 */

	// In the same tab:

		// location.href = location.href.replace(/&list=.*/, "");

	// In a new tab:

		window.open(location.href.replace(/&list=.*/, "")).focus();

END Monday, April 15th, 2024 at 6:55 PM

################################################################################

BEGIN Youtube Thumbnail Grabber

ICON javascript.ico

const video_id = location.href.match(/(?<=v=).{11}/)[0];
const url = `https://img.youtube.com/vi/${video_id}/default.jpg`;

window.open(url).focus();

END Sunday, April 21st, 2024 at 5:54 PM

################################################################################

BEGIN GET Killer

ICON javascript.ico

// To remove URL parameters after a GET request.

location.href = location.href.replace(/\?.*/, '');

END Monday, April 22nd, 2024 at 2:08 AM

################################################################################

BEGIN YouTube Playlist Abstractor

ICON javascript.ico

function getQueryParameters(url) {

	let params = {};

	url.match(/(?<=\?)[^#]*/)[0].split("&").forEach(param => {

		let [key, value] = param.split("=");

		params[key] = value;

	});

	return params;

}

let params = getQueryParameters(location.href);

location.href = `https://www.youtube.com/playlist?list=${params['list']}`;

END Friday, April 26th, 2024 at 2:13 AM
