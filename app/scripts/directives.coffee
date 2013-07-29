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
    todoList: '=todos'
    title: '@'
    emptyMessage: '@'
    energy: '@'
    removeFunc: '&remove'
    addFunc: '&add'
    updateFunc: '&update'
  link: (scope, elem, attrs) ->
    console.log scope.todoList
    if scope.energy isnt ""
      scope.todos = scope.todoList[scope.energy]
    else
      scope.$watch 'todoList', ->
        scope.todos = scope.todoList.high.concat scope.todoList.low
      , true

    if scope.emptyMessage is "" then scope.emptyMessage = "You have no tasks in this list."

    # remove the default form if there's a custom one in use
    if attrs.customForm?
      for form in elem.find('form')
        if form.className.match /default-form/
          form.remove()
          break

    scope.getEnergy = (id) ->
      if scope.energy isnt "" then scope.energy
      else
