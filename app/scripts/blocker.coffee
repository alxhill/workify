angular.module('workify').controller 'BlockerCtrl', ($scope, $timeout) ->

  $scope.remaining = 5
  $scope.done = false

  timeout = $timeout timefunc = ->
    if $scope.remaining is 0
      chrome.tabs.getCurrent (tab) ->
        chrome.runtime.sendMessage method: 'unblock', args: [tab]
      $scope.done = true
    else
      $scope.remaining--
      $timeout timefunc, 1000
  , 1000
