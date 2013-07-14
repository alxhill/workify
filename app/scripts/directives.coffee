angular.module('workify').directive 'enterKey', ->
  (scope, elem, attrs) ->
    elem.bind 'keydown', (e) ->
      if e.keyCode is 13
        scope.$apply attrs.enterKey

angular.module('workify').directive 'todoList', ($timeout) ->
  restrict: 'E'
  replace: true
  transclude: true
  templateUrl: 'todo-list.html'
  scope:
    title: '@'
    todos: '='
    removeFunc: '&remove'
    addFunc: '&add'
    updateFunc: '&update'
    emptyMessage: '@'
  link: (scope, elem, attrs) ->

    if emptyMessage is "" then emptyMessage = "You have no tasks in this list."

    # remove the default form if there's a custom one in use
    if attrs.customForm?
      for form in elem.find('form')
        if form.className.match /default-form/
          form.remove()
          break
