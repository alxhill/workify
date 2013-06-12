angular.module('workify').controller 'BlockCtrl', ($scope) ->

  $scope.blocked = false

  # this should be done based on the chrome.tabs.onMoved event
  # and using the url from the tab
  # chrome.storage.local.get 'blocklist', ({blocklist}) ->
  #   urlParser = document.createElement 'a'
  #   urlParser.href = window.location.href
  #   $scoped.blocked = urlParser.hostname in blocklist


  $scope.toggle = ->
    $scope.blocked = not $scope.blocked

  return
