// Generated by CoffeeScript 1.6.3
angular.module('workify').controller('BlockerCtrl', function($scope, $timeout) {
  var timeout;
  $scope.remaining = 5;
  return timeout = $timeout(function() {
    $scope.done = true;
    console.log('timer done. This would return to the original page if I\'d written that bit yet');
    return chrome.runtime.sendMessage("endBlock");
  }, $scope.remaining * 1000);
});
