"use strict"

angular.module('workify').controller 'TodoCtrl', ($scope, Todos) ->

  chrome.runtime.onMessage.addListener (msg) ->
    if msg is "updateList"
      # this is done for performance - directly attaching the promise clears the list.
      $scope.$apply -> Todos.get().then (todolist) -> $scope.todos = todolist

  $scope.todos = Todos.get()

  $scope.update = -> Todos.update()

  $scope.addTodo = (title, energy) ->
    Todos.add title, energy

  $scope.removeTodo = (id) -> Todos.remove id

  return
