"use strict"

angular.module('workify').controller 'TodoCtrl', ($scope, Todos) ->

  chrome.runtime.onMessage.addListener (msg) ->
    if msg is "updateList"
      $scope.$apply -> Todos.get().then (todolist) -> $scope.todos = todolist

  Todos.get().then (todolist) -> $scope.todos = todolist

  # semi temporary solution, filters create digest loops
  watchFunc = (todoList) ->
    $scope.highTodos = _.where todoList, energy: 'high'
    $scope.lowTodos = _.where todoList, energy: 'low'
  $scope.$watch 'todos', watchFunc

  $scope.update = -> Todos.update()

  $scope.addTodo = (title, level) ->
    Todos.add
      title:  title
      energy: level

  $scope.removeTodo = (id) -> Todos.remove id

  return
