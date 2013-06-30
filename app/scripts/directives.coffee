angular.module('workify').directive 'todoList', ->
  restrict: 'E'
  replace: true
  transclude: true
  templateUrl: 'todo-list.html'
  scope:
    title: '@'
    todos: '='
    removeFunc: '&remove'
    addFunc: '&add'
    emptyMessage: '@'
  link: (scope, elem, attrs) ->

    if emptyMessage is "" then emptyMessage = "You have no tasks in this list."

    if attrs.customForm?
      for form in elem.find('form')
        if form.className.match /default-form/
          form.remove()
          break
