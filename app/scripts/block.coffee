angular.module('workify').controller 'BlockCtrl', ($scope) ->

  $scope.blocked = false

  $scope.toggle = ->
    $scope.blocked = not $scope.blocked

  return
