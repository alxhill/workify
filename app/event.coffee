# just because typing chrome.storage.local every time is a pain in the arse
get = (name, cb) -> chrome.storage.local.get name, cb
set = (obj) -> chrome.storage.local.set obj

# set up the basic backend objects for workify
chrome.runtime.onInstalled.addListener ->
  set
    blocklist: ["apple.com", "10fastfingers.com"]
    restoreUrl: {}
    safeTabs: []
    todolist: [
      title: "Populate Workify with the things you want to do"
      done: false
      id: 0
    ,
      title: "Finish building Workify"
      done: false
      id: 1
    ,
      title: "Learn Angular JS"
      done: false
      id: 2
    ]

# the <a> tag can parse out the hostname (and other properties) of a url.
urlParser = document.createElement 'a'

# simple function to replace the contents of tab with the workify block page
block = (tab) ->
  chrome.tabs.update tab.id, url: chrome.runtime.getURL('block.html'), (newTab) ->
    get 'restoreUrl', ({restoreUrl}) ->
      restoreUrl[newTab.id] = tab.url
      set restoreUrl: restoreUrl

# work out if a page should be blocked, then execute a callback with the result
shouldBlock = (tab, cb) ->
  get 'blocklist', ({blocklist}) ->
    get 'restoreUrl', ({restoreUrl}) ->
      get 'safeTabs', ({safeTabs}) ->
        blockTab = false
        for url in blocklist
          if tab.id not of restoreUrl and tab.id not in safeTabs
            urlParser.href = tab.url
            if urlParser.hostname in blocklist
              blockTab = true
        cb blockTab

chrome.tabs.onUpdated.addListener (id, changeInfo, tab) ->
  shouldBlock tab, (blk) -> if blk then block tab

chrome.tabs.onReplaced.addListener (newId, oldId) ->
  get 'safeTabs', ({safeTabs}) ->
    if oldId in safeTabs
      delete safeTabs[oldId]
      safeTabs.push newId
      set safeTabs: safeTabs
    else
      chrome.tabs.get newId, (tab) -> shouldBlock tab, (blk) -> if blk then block tab

# take a tab out of the
chrome.tabs.onRemoved.addListener (id) ->
  get 'safeTabs', ({safeTabs}) ->
    if id in safeTabs
      safeTabs.splice(safeTabs.indexOf(id), 1)
      set safeTabs: safeTabs

# unblocks a page on receiving the 'unblock' message from the script
chrome.runtime.onMessage.addListener (msg, {tab}, sendResponse) ->
  if msg is 'unblock'
    get 'restoreUrl', ({restoreUrl}) ->
      console.log 'unblocking page with url', restoreUrl[tab.id]
      chrome.tabs.update tab.id, url: restoreUrl[tab.id], (newTab) ->
        delete restoreUrl[tab.id]
        set restoreUrl: restoreUrl
        get 'safeTabs', ({safeTabs}) ->
          safeTabs.push newTab.id
          set safeTabs: safeTabs
