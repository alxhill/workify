angular.module('workify').controller 'BlockCtrl', ($scope, $window) ->

  $scope.blocked = false

  $scope.toggle = ->
    $scope.blocked = not $scope.blocked

  return
