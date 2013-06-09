angular.module('workify').controller 'BlockerCtrl', ($scope, $timeout) ->

  $scope.remaining = 30

  countdown = window.setInterval ->
    $scope.$apply -> $scope.remaining--
    if $scope.remaining is 0
      $scope.$emit 'timeout'
      window.clearInterval countdown
  , 1000

  $scope.$on 'timeout', ->
    console.log 'timer done. This would return to the original page if I\'d written that bit yet'
