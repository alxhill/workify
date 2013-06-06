block = (tab) ->
  if tab.url.match /facebook/
    chrome.tabs.remove tab.id
    chrome.tabs.create url: chrome.runtime.getURL "block.html"

chrome.tabs.onUpdated.addListener (id, change_info, tab) -> block tab

chrome.tabs.onReplaced.addListener (new_id, old_id) ->
  chrome.tabs.get new_id, (tab) -> block tab
