bannedUrls = ["apple", "10fastfingers"]

block = (tab) ->
  chrome.tabs.update tab.id, url: chrome.runtime.getURL("block.html"), (newTab) ->
    console.log tab.id, ' to ', newTab.id
    return
  return

shouldBlock = (tabUrl) ->
  for url in bannedUrls
    if tabUrl.match RegExp(url)
      return true

  return false

chrome.tabs.onUpdated.addListener (id, changeInfo, tab) ->
  if shouldBlock tab.url
    block tab

chrome.tabs.onReplaced.addListener (newId, oldId) ->
  chrome.tabs.get newId, (tab) ->
    if shouldBlock tab.url
      block tab

# cb = (e) ->
#   console.log e
#   if e.tabId
#     chrome.tabs.update e.tabId, url: chrome.runtime.getURL("block.html"), (newTab) ->
#       console.log newTab
#       return
#   return
