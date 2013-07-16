// Generated by CoffeeScript 1.6.3
(function() {
  "use strict";
  angular.module('workify').controller('TodoCtrl', function($scope, Todos) {
    var watchFunc;
    chrome.runtime.onMessage.addListener(function(msg) {
      if (msg === "updateList") {
        return $scope.$apply(function() {
          return Todos.get().then(function(todolist) {
            return $scope.todos = todolist;
          });
        });
      }
    });
    $scope.todos = Todos.get();
    watchFunc = function(todoList) {
      $scope.highTodos = _.where(todoList, {
        energy: 'high'
      });
      return $scope.lowTodos = _.where(todoList, {
        energy: 'low'
      });
    };
    $scope.$watch('todos', watchFunc);
    $scope.update = function() {
      return Todos.update();
    };
    $scope.addTodo = function(title, level) {
      return Todos.add({
        title: title,
        energy: level
      });
    };
    $scope.removeTodo = function(id) {
      return Todos.remove(id);
    };
  });

}).call(this);
