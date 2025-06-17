/*##############################################################################

FILENAME: bookmarklets.js
AUTHOR: Zachary Krepelka
DATE: Thursday, December 21st, 2023
ABOUT: bookmarklets for the web browser
ORIGIN: https://github.com/zachary-krepelka/bookmarks.git
UPDATED: Monday, June 16th, 2025 at 8:23 PM

 This source code can be packaged into an importable file using my
 bookmarklet-parsing Perl script.  Find it in my GitHub repository as stated
 above.  The words in all caps are meta keywords recognized by the parser.
 *This file contains instances of invalid JavaScript.*

##############################################################################*/

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

//##############################################################################

BEGIN Greatest Common Divisor

FOLDER Math
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

//##############################################################################

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

//##############################################################################

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

//##############################################################################

BEGIN com2net
FOLDER URL Manipulators
ICON javascript.ico

location.href = location.href.replace(/com/, 'net');

END Monday, February 5th, 2024 at 8:49 PM

//##############################################################################

BEGIN Playlist Plucker
FOLDER YouTube Tools
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

//##############################################################################

BEGIN Thumbnail Grabber
FOLDER YouTube Tools
ICON javascript.ico

const video_id = location.href.match(/(?<=v=).{11}/)[0];
const url = `https://img.youtube.com/vi/${video_id}/default.jpg`;

window.open(url).focus();

END Sunday, April 21st, 2024 at 5:54 PM

//##############################################################################

BEGIN Query Killer
FOLDER URL Manipulators
ICON javascript.ico

location.href = location.href.replace(/\?.*/, '');

END Monday, April 22nd, 2024 at 2:08 AM

//##############################################################################

BEGIN Playlist Abstractor
FOLDER YouTube Tools
ICON javascript.ico

function getQueryParameters(url) {

	let params = {};

	url.match(/(?<=\?)[^#]*/)[0].split("&").forEach(param => {

		let [key, value] = param.split("=");

		params[key] = value;

	});

	return params;

}

let id = getQueryParameters(location.href)['list'];

location.href = `https://www.youtube.com/playlist?list=${id}`;

END Friday, April 26th, 2024 at 2:13 AM

//##############################################################################

BEGIN Fragment Killer
FOLDER URL Manipulators
ICON javascript.ico

/* This bookmark strips the fragment from the current URL.

	+-------------------------------------------------------+
	|                                                       |
	|  https://en.wikipedia.org/wiki/URI_fragment#Examples  |
	|                                            \       /  |
	|  This URL points to a page giving           -------   |
	|  examples of fragments with the URL            |      |
	|  itself aptly serving as an example.        Fragment  |
	|                                                       |
	+-------------------------------------------------------+

*/ location.href = location.href.replace(/#[^#]+$/, '');

END Friday, June 7th, 2024 @ 9:45 PM

//##############################################################################

BEGIN Video Collector
FOLDER YouTube Tools
ICON javascript.ico

// Extract all video IDs from a YouTube page. Copy to clipboard.

 navigator
.clipboard
.writeText(Array
.from(document
.querySelectorAll('[id=video-title-link'))
.map((element) => element.href.split('?v=')[1])
.join("\r\n"));

END Sunday, September 8th, 2024 @ 12:03 AM

//##############################################################################

BEGIN Image Extractor
ICON javascript.ico

 navigator
.clipboard
.writeText(Array
.from(document
.getElementsByTagName('img'))
.map((e) => e
.getAttribute('src'))
.join("\r\n"));

END Thursday, October 3rd, 2024

//##############################################################################

// quora.com/Is-there-a-way-of-watching-YouTube-videos-at-higher-than-2x-speed

BEGIN Set Playback Speed
FOLDER YouTube Tools/Speed
ICON javascript.ico

const speed = prompt("Enter a video playback speed.", "1");

document.getElementsByTagName("video")[0].playbackRate = speed;

END Wednesday, October 16th, 2024

// The following three bookmarklets should be put directly
// on the bookmark bar for ease of accessibility. I put them
// into a nested folder for the sake of organization.

BEGIN Slower
FOLDER YouTube Tools/Speed
ICON javascript.ico

document.getElementsByTagName("video")[0].playbackRate -= .25;

END

BEGIN Faster
FOLDER YouTube Tools/Speed
ICON javascript.ico

document.getElementsByTagName("video")[0].playbackRate += .25;

END

BEGIN Reset
FOLDER YouTube Tools/Speed
ICON javascript.ico

document.getElementsByTagName("video")[0].playbackRate = 1;

END

//##############################################################################

BEGIN Print Google AI Overview
FOLDER Scrapers
ICON javascript.ico

let aiOverview = document.querySelector('.LT6XE').cloneNode(true);

let junk = aiOverview.querySelectorAll('.niO4u,.WDoJJe');

Array.from(junk).forEach(item => item.remove());

let printable = window.open();

printable.document.write(aiOverview.innerHTML);
printable.document.body.insertAdjacentHTML('afterbegin',
	`<p>${getStrippedDownGoogleSearchURL()}</p>`);
printable.document.close();
printable.focus();
printable.print();

function getStrippedDownGoogleSearchURL() {

	let query = getQueryParameters(location.href)['q'];

	return `https://www.google.com/search?q=${query}`
}

function getQueryParameters(url) {

	let params = {};

	url.match(/(?<=\?)[^#]*/)[0].split("&").forEach(param => {

		let [key, value] = param.split("=");

		params[key] = value;
	});

	return params;
}

END Wednesday, March 19th, 2025

//##############################################################################

BEGIN Get User Agent
FOLDER Scrapers
ICON javascript.ico
alert(navigator.userAgent);
END Monday, June 16th, 2025

//##############################################################################
