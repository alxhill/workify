TodoCtrl = ($scope) ->
  $scope.todos = [
    title: "Build Workify"
    done: false
  ,
    title: "Make workify save to chrome localstorage"
    done: false
  ,
    title: "Make workify block pages"
    done: false
  ,
    title: "Pass exams"
    done: false
  ,
    title: "Learn WebGL"
    done: false
  ]

  $scope.addTodo = ->
    unless $scope.todoInput is ""
      $scope.todos.push title: $scope.todoInput, done: false
      $scope.todoInput = ""
