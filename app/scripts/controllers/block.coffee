"use strict"

angular.module('workify').controller 'BlockCtrl', ($scope) ->

  # goddammit coffeescript
  Tab = null
  url = null

  chrome.runtime.getBackgroundPage (bg) ->
    Tab = bg.Tab
    chrome.tabs.query active: true, windowType: 'normal', currentWindow: true, (tabs) ->
      tab = tabs[0]
      url = tab.url
      Tab.inBlocklist tab.url, ->
        $scope.$apply -> $scope.blocked = true

  $scope.blocked = false

  # this probably shouldn't assume the variables are set, but making it not
  # is significantly more complex. So meh.
  $scope.toggle = ->
    console.log Tab
    if not $scope.blocked
      Tab.addToBlocklist url
    else
      Tab.removeFromBlocklist url
    $scope.blocked = not $scope.blocked

  return
