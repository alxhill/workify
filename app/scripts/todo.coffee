"use strict"

angular.module('workify').controller 'TodoCtrl', ($scope) ->

  chrome.runtime.onMessage.addListener (msg) ->
    if msg is "updateList"
      chrome.storage.local.get 'todolist', (value) ->
        $scope.$apply -> $scope.load value

  $scope.save = ->
    chrome.storage.local.set todolist: $scope.todos
    chrome.runtime.sendMessage "updateList"

  $scope.save()

  $scope.load = (value) ->
    if value
      value.todolist ?= []
      $scope.todos  = value.todolist
      $scope.nextid = 1 + _.max($scope.todos, "id").id
    else
      $scope.todos = []
      $scope.nextid = 0

  $scope.addTodo = (title, level) ->
    console.log "title", title, "level", level
    $scope.todos.push
      title:  title
      done:   false
      id:     $scope.nextid++
      energy: level

    # this annoys me but it's the simplest way with one controller
    $scope.todoInput = ""
    $scope.lowInput  = ""
    $scope.highInput = ""
    $scope.save()

  $scope.clearComplete = ->
    $scope.todos = _.where $scope.todos, done: false
    $scope.save()

  $scope.remove = (id) ->
    $scope.todos = _.reject $scope.todos, (el) -> el.id is id
    $scope.save()

  return
