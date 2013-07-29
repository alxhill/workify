"use strict"

angular.module('workify').service 'Todos',
  class Todos
    constructor: (@$q, @$rootScope) ->
      @reset()
      @loaded = false

    reset: ->
      @qTodolists = @$q.defer()

    get: ->
      # make sure to get a new deferred object when this is called
      if @loaded then @reset()
      chrome.storage.local.get 'todolist', ({todolist}) =>
        if todolist?
          @$rootScope.$apply => @qTodolists.resolve todolist
        else
          newTodolist =
            high: []
            low: []
          @$rootScope.$apply => @qTodolists.resolve newTodolist
          @update(newTodolist)
        @loaded = true

      return @qTodolists.promise

    _update: (todolist) ->
      chrome.storage.local.set todolist: todolist
      chrome.runtime.sendMessage "updateList"

    update: (todolists) ->
      if todolists?
        @_update todolists
      else
        @qTodolists.promise.then (todolists) =>
          @_update todolists

    add: (title, energy) ->
      @qTodolists.promise.then (todolists) =>
        @_getNextId().then (nextId) =>
          todo =
            id: nextId
            title: title
          todolists[energy].push todo
          @update(todolists)

    remove: (id) ->
      @qTodolists.promise.then (todolists) =>
        console.log todolists
        for energy, todolist of todolists
          for todo in todolist
            console.log todo.id, id
            if todo.id is id
              todolist.splice todolist.indexOf(todo), 1
              break
        @update(todolist)

    _getNextId: ->
      qId = @$q.defer()

      @qTodolists.promise.then (todolists) ->
        todos = _(todolists).values().flatten().value()
        if todos.length isnt 0
          qId.resolve 0
        else
          qId.resolve 1 + _.max(todos, "id").id

      return qId.promise
