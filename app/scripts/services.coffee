"use strict"

angular.module('workify').service 'Todos',
  class Todos
    constructor: (@$q, @$rootScope) ->
      @qTodolist = @$q.defer()
      @loaded = false

    get: ->
      # make sure to get a new deferred object when this is called
      if @loaded then @qTodolist = @$q.defer()
      chrome.storage.local.get 'todolist', ({todolist}) =>
        if todolist?
          @$rootScope.$apply => @qTodolist.resolve todolist
        else
          @$rootScope.$apply => @qTodolist.resolve []
        @loaded = true

      return @qTodolist.promise

    _update: (todolist) ->
      chrome.storage.local.set todolist: todolist
      chrome.runtime.sendMessage "updateList"

    update: (todolist) ->
      if todolist?
        @_update todolist
      else
        @qTodolist.promise.then (todolist) =>
          @_update todolist

    add: (todo) ->
      @qTodolist.promise.then (todolist) =>
        @_getNextId().then (nextId) =>
          todo.id = nextId
          todolist.push todo
          @update(todolist)

    remove: (id) ->
      @qTodolist.promise.then (todolist) =>
        for todo in todolist
          if todo.id is id
            todolist.splice todolist.indexOf(todo), 1
            break
        @update(todolist)

    _getNextId: ->
      qId = @$q.defer()

      @qTodolist.promise.then (todolist) ->
        if todolist.length is 0
          qId.resolve 0
        else
          qId.resolve 1 + _.max(todolist, "id").id

      return qId.promise
