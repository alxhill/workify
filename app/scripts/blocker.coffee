angular.module('workify').controller 'BlockerCtrl', ($scope, $timeout) ->

  $scope.remaining = 5

  timeout = $timeout ->
    $scope.done = true
    console.log 'timer done. This would return to the original page if I\'d written that bit yet'
    chrome.runtime.sendMessage "unblock"
  , $scope.remaining*1000

