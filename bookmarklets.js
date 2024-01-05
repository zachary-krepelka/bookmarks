
// FILENAME: bookmarklets.js
// AUTHOR: Zachary Krepelka
// DATE: Thursday, December 21st, 2023
// DESCRIPTION: bookmarklets for the web browser
// UPDATED: Wednesday, January 3rd, 2024   9:03 PM

/*******************************************************************************

FAVICON GRABBER

	This bookmarklet grabs the current website's favicon.

	See here for more information:

		https://dev.to/derlin/
		get-favicons-from-any-website-using-a-hidden-google-api-3p1e

*/

javascript:(function(){
	let url = "http://www.google.com/s2/favicons?";
	let domain = "domain=" + location.href;
	let size = "&sz=" + prompt("What size?", "16");
	location.href = url + domain + size;
})();

/*******************************************************************************

GOOGLE CHROME EXTENSION LIST

	This bookmarklet helps the user generate a list of installed Google
	Chrome extensions.  I adapted the code from an answer on Super User into
	a bookmarklet for ease of use.  See here:

		https://superuser.com/a/1691722

	The process involves accessing chrome://extensions.  JavaScript usage is
	restricted on Chrome webpages, e.g., chrome://path, so some effort is
	required on the part of the user.  Instructions are provided in a popup.

*/

javascript:(function(){
var popup = window.open(null, null, 'width=250, height=150');
var content = `
<html>
	<body>
		<p> Instructions:
			<ol>
				<li>Open <code>chrome://extensions</code>.</li>
				<li>Press <kbd>F12</kbd> & click 'Console'.</li>
				<li>Paste your clipboard.</li>
				<li>Press <kbd>Enter</kbd>.</li>
			</ol>
		</p>
	</body>
</html>`;
popup.document.write(content);
navigator.clipboard.writeText("console.log(
document.querySelector('extensions-manager').
extensions_.map(({id, name, state, webStoreUrl}) => (name)).join('\\n'));");
})();
