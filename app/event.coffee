"use strict"

# just because typing chrome.storage.local every time is a pain
# also means we can globally switch it to sync without much effort.
get = (name, cb) -> chrome.storage.local.get name, cb
set = (obj) -> chrome.storage.local.set obj

Array::remove = (element) ->
  if element in this
    @splice @indexOf(element), 1

# set up the basic backend objects for workify
chrome.runtime.onInstalled.addListener ->
  set
    blocklist: ["reddit.com", "10fastfingers.com", "facebook.com"]
    restoreUrl: {}
    safeTabs: []
    todolist:
      high: [
        id:0
        title:"Finish Workify v0.1"
      ,
        id:1
        title:"Make a HN iOS 7 app"
      ,
        id:3
        title:"Make a JavaScript compiler"
      ,
        id:4
        title:"Connect ResourceFoundry to the back end"
      ,
        id:10
        title:"Write article on Opinion and Community"
      ]
      low: [
        id:8
        title:"Learn about parsers and lexers"
      ,
        id:9
        title:"Read The Lean Startup"
      ,
        id:11
        title:"Gather resources for JobFoundry"
      ,
        id: 12
        title: "Finish the landing page for Workify"
      ,
        id: 13
        title: "Improve the Workify blog post"
      ,
        id: 14
        title: "Research driving lessons"
      ]

### Functions for dealing with tabs and urls ###
### This is accesible from outside the background page ###
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

  # work out if a page should be blocked, then execute a callback with the result.
  # differs from inBlocklist as it checks if the page is safe or currently blocked
  shouldBlock: (tab, cb) ->
    get 'restoreUrl', ({restoreUrl}) ->
      get 'safeTabs', ({safeTabs}) ->
        blockTab = false
        if tab.openerTabId? and tab.openerTabId in safeTabs
          # could be a page we shouldn't block. But we need
          # check that it's the same actual page to block, and
          # if it isn't, don't put it in safeTabs
          chrome.tabs.get tab.openerTabId, (openerTab) ->
            if Tab.normaliseUrl(openerTab.url) is Tab.normaliseUrl(tab.url)
              safeTabs.push tab.id
            else if tab.id in safeTabs
              safeTabs.splice safeTabs.indexOf(tab.id), 1
            set safeTabs: safeTabs


        Tab.inBlocklist tab.url, ->
          if tab.id not of restoreUrl and tab.id not in safeTabs
            blockTab = true
          cb.call Tab, blockTab

  addToBlocklist: (url) ->
    # make sure we don't block normal chrome pages/itself.
    unless url.indexOf("chrome") is 0
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

window.Tab = Tab
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

# take a tab out of the safeTabs array
chrome.tabs.onRemoved.addListener (id) ->
  get 'safeTabs', ({safeTabs}) ->
    if id in safeTabs
      safeTabs.splice(safeTabs.indexOf(id), 1)
      set safeTabs: safeTabs

# Allows access to the Tab functions through messaging.
# May be removed in a later release to be replaced with getBackgroundPage
chrome.runtime.onMessage.addListener (msg, {tab}, sendResponse) ->
  if msg.method?
    msg.args ?= []
    msg.args.push sendResponse # for functions that take a callback
    Tab[msg.method].apply Tab, msg.args
    # onMessage must return true if the sendResponse is to be used
    return msg.method in ["shouldBlock", "inBlocklist"]
