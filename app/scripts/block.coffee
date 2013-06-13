angular.module('workify').controller 'BlockCtrl', ($scope) ->

  Tab = null
  url = null
  chrome.runtime.getBackgroundPage (bg) ->
    Tab = bg.Tab
    chrome.tabs.query active: true, windowType: 'normal', (tabs) ->
      tab = tabs[0]
      url = tab.url
      Tab.inBlocklist tab.url, ->
        $scope.$apply -> $scope.blocked = true

  $scope.blocked = false

  # it's pretty bad to assume the variables are set, but making it not like
  # this is significantly more complex. So meh.
  $scope.toggle = ->
    if $scope.blocked
      Tab.addToBlocklist url
    else
      Tab.removeFromBlocklist url
    $scope.blocked = not $scope.blocked

  return
