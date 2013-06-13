// Generated by CoffeeScript 1.6.3
angular.module('workify').controller('BlockerCtrl', function($scope, $timeout) {
  var timefunc, timeout;
  $scope.remaining = 30;
  $scope.done = false;
  return timeout = $timeout(timefunc = function() {
    if ($scope.remaining === 0) {
      chrome.tabs.getCurrent(function(tab) {
        return chrome.runtime.sendMessage({
          method: 'unblock',
          args: [tab]
        });
      });
      return $scope.done = true;
    } else {
      $scope.remaining--;
      return $timeout(timefunc, 1000);
    }
  }, 1000);
});
