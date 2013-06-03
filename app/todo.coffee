angular.module('workify').controller 'TodoCtrl', ($scope) ->

  chrome.storage.local.get 'todolist', (value) ->
    $scope.$apply -> $scope.load value

  $scope.save = -> chrome.storage.local.set todolist: $scope.todos

  $scope.load = (value) ->
    if value and value.todolist
      $scope.todos = value.todolist
    else
      $scope.todos = []
      $scope.addTodo "Build Workify"
      $scope.addTodo "Make workify save to chrome localstorage"
      $scope.addTodo "Make workify block pages"
      $scope.addTodo "Pass exams"
      $scope.addTodo "Learn WebGL"
      $scope.save()

  $scope.nextid = 0

  $scope.addTodo = (title) ->
    if title?
      $scope.todos.push title: title, done: false, id: $scope.nextid++
      $scope.todoInput = ""
      $scope.save()

  return
