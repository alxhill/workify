angular.module('workify').controller 'TodoCtrl', ($scope) ->

  chrome.runtime.onMessage.addListener (msg, {tab}) ->
    if msg is "updateList"
      chrome.storage.local.get 'todolist', (value) ->
        $scope.$apply -> $scope.load value

  $scope.save = ->
    chrome.storage.local.set todolist: $scope.todos
    chrome.runtime.sendMessage "updateList"

  $scope.save()

  $scope.load = (value) ->
    if value and value.todolist?.length > 0
      $scope.todos = value.todolist
      $scope.nextid = $scope.todos.length
    # else
    #   $scope.nextid = 0
    #   $scope.todos = []
    #   $scope.addTodo [
    #     "Build Workify",
    #     "Make workify save to chrome localstorage",
    #     "Make workify block pages",
    #     "Pass exams",
    #     "Learn WebGL"
    #   ]
    #   $scope.save()


  $scope.addTodo = (title) ->
    if title?
      if angular.isArray(title)
        $scope.todos = $scope.todos.concat _.map title, (el) -> title: el, done: false, id: $scope.nextid++
      else
        $scope.todos.push title: title, done: false, id: $scope.nextid++

      $scope.todoInput = ""
      $scope.save()

  return
