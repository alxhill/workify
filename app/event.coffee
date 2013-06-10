bannedUrls = ["apple.com", "10fastfingers.com"]
restoreUrl = {} # map of tab id to url to restore
safeTabs = [] # tabs that are allowed to be on banned pages

# the a tag can parse out the hostname (and other properties) of a url.
urlParser = document.createElement 'a'

block = (tab) ->
  chrome.tabs.update tab.id, url: chrome.runtime.getURL("block.html"), (newTab) ->
    restoreUrl[newTab.id] = tab.url

shouldBlock = (tab) ->
  for url in bannedUrls
    if tab.id not of restoreUrl and tab.id not in safeTabs
      urlParser.href = tab.url
      if urlParser.hostname in bannedUrls
        return true
  return false

chrome.tabs.onUpdated.addListener (id, changeInfo, tab) ->
  if shouldBlock tab then block tab

chrome.tabs.onReplaced.addListener (newId, oldId) ->
  if oldId in safeTabs
    delete safeTabs[oldId]
    safeTabs.push newId
  else
    chrome.tabs.get newId, (tab) -> if shouldBlock tab then block tab

chrome.tabs.onRemoved.addListener (id) -> if id in safeTabs then safeTabs.splice(safeTabs.indexOf(id), 1)

chrome.runtime.onMessage.addListener (msg, {tab}, sendResponse) ->
  if msg is "unblock"
    chrome.tabs.update tab.id, url: restoreUrl[tab.id], (newTab) ->
      delete restoreUrl[tab.id]
      safeTabs.push newTab.id
