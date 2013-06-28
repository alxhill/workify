"use strict"

angular.module('workify').controller 'TodoCtrl', ($scope, Todos) ->

  chrome.runtime.onMessage.addListener (msg) ->
    if msg is "updateList"
      # this is done for performance - directly attaching the promise clears the list.
      $scope.$apply -> Todos.get($scope).then (todolist) -> $scope.todos = todolist

  $scope.todos = Todos.get($scope)

  $scope.update = -> Todos.update()

  $scope.addTodo = (title, level) ->
    Todos.add
      title:  title
      done:   false
      energy: level

    $scope.input = {}

  $scope.remove = (id) ->
    Todos.remove id

  return
