# just because typing chrome.storage.local every time is a pain
get = (name, cb) -> chrome.storage.local.get name, cb
set = (obj) -> chrome.storage.local.set obj

# set up the basic backend objects for workify
chrome.runtime.onInstalled.addListener ->
  set
    blocklist: ["reddit.com", "10fastfingers.com", "facebook.com", "news.ycombinator.com"]
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

### Functions for dealing with tabs and urls ###

Tab =
  normaliseUrl: (url) ->
    # the <a> tag can parse out the hostname (and other properties) of a url.
    urlParser = document.createElement 'a'
    urlParser.href = url
    # match both site.com and www.site.com
    host = urlParser.hostname.match(/(www\.)?(.*)/)?[2]
    return host

  block: (tab) ->
    chrome.tabs.update tab.id, url: chrome.runtime.getURL('block.html'), (newTab) ->
      get 'restoreUrl', ({restoreUrl}) ->
        restoreUrl[newTab.id] = tab.url
        set restoreUrl: restoreUrl

  unblock: (tab) ->
    get 'restoreUrl', ({restoreUrl}) ->
      chrome.tabs.update tab.id, url: restoreUrl[tab.id], (newTab) ->
        delete restoreUrl[tab.id]
        set restoreUrl: restoreUrl
        get 'safeTabs', ({safeTabs}) ->
          safeTabs.push newTab.id
          set safeTabs: safeTabs

  # work out if a page should be blocked, then execute a callback with the result
  shouldBlock: (tab, cb) ->
    get 'restoreUrl', ({restoreUrl}) ->
      get 'safeTabs', ({safeTabs}) ->
        blockTab = false
        Tab.inBlocklist tab.url, ->
          if tab.id not of restoreUrl and tab.id not in safeTabs
            blockTab = true
          cb.call Tab, blockTab

  addToBlocklist: (url) ->
    host = Tab.normaliseUrl url
    get 'blocklist', ({blocklist}) ->
      blocklist.push host
      set blocklist: blocklist

  removeFromBlocklist: (url) ->
    host = Tab.normaliseUrl url
    get 'blocklist', ({blocklist}) ->
      if host in blocklist
        blocklist.splice(blocklist.indexOf(host), 1)
      set blocklist: blocklist

  # execute a callback if the url should be blocked
  inBlocklist: (url, cb) ->
    host = Tab.normaliseUrl url
    get 'blocklist', ({blocklist}) ->
      if host in blocklist then cb()

### Listen to chrome.tabs events ###

chrome.tabs.onUpdated.addListener (id, changeInfo, tab) ->
  Tab.shouldBlock tab, (blk) -> if blk then Tab.block tab

chrome.tabs.onReplaced.addListener (newId, oldId) ->
  get 'safeTabs', ({safeTabs}) ->
    if oldId in safeTabs
      delete safeTabs[oldId]
      safeTabs.push newId
      set safeTabs: safeTabs
    else
      chrome.tabs.get newId, (tab) -> Tab.shouldBlock tab, (blk) -> if blk then Tab.block tab

# take a tab out of the
chrome.tabs.onRemoved.addListener (id) ->
  get 'safeTabs', ({safeTabs}) ->
    if id in safeTabs
      safeTabs.splice(safeTabs.indexOf(id), 1)
      set safeTabs: safeTabs

# allows access to the BlockMananger functions through messaging
chrome.runtime.onMessage.addListener (msg, {tab}, sendResponse) ->
  if msg.method?
    msg.args ?= []
    msg.args.push sendResponse # for functions that take a callback
    Tab[msg.method].apply Tab, msg.args
    # onMessage must return true if the sendResponse is to be used
    return msg.method in ["shouldBlock", "inBlocklist"]
