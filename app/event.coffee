blocklist = ["apple.com", "10fastfingers.com"]
restoreUrl = {} # map of tab id to url to restore
safeTabs = [] # tabs that are allowed to be on banned pages

# set up the basic backend objects for workify
chrome.runtime.onInstalled.addListener ->
  chrome.storage.local.set
    blocklist: ["apple.com", "10fastfingers.com"]
    restoreUrl: {}
    safeTabs: {}
    todolist: [
      title: "Populate Workify with the things you want to do"
      done: false
      id: 0
    ]

# the a tag can parse out the hostname (and other properties) of a url.
urlParser = document.createElement 'a'

block = (tab) ->
  chrome.tabs.update tab.id, url: chrome.runtime.getURL("block.html"), (newTab) ->
    restoreUrl[newTab.id] = tab.url

shouldBlock = (tab, cb) ->
  chrome.storage.local.get 'blocklist', ({blocklist}) ->
    for url in blocklist
      if tab.id not of restoreUrl and tab.id not in safeTabs
        urlParser.href = tab.url
        if urlParser.hostname in blocklist
          block tab

chrome.tabs.onUpdated.addListener (id, changeInfo, tab) -> shouldBlock tab

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
