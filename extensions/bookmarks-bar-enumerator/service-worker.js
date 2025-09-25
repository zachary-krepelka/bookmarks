// FILENAME: service-worker.js
// AUTHOR: Zachary Krepelka
// DATE: Wednesday, September 24th, 2025

chrome.action.onClicked.addListener(() => {
  chrome.bookmarks.getTree((tree) => {
    const root = tree[0];
    const bar = root.children.find(node => node.folderType === "bookmarks-bar");
    let count = 0;
    for (let node of bar.children) {
      chrome.bookmarks.update(node.id, { title: String(count++) });
    }
  });
});
