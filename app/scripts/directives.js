// Generated by CoffeeScript 1.6.3
angular.module('workify').directive('todoList', function() {
  return {
    restrict: 'E',
    replace: true,
    transclude: true,
    templateUrl: 'todo-list.html',
    scope: {
      title: '@',
      todos: '=',
      removeFunc: '&remove',
      addFunc: '&add',
      emptyMessage: '@'
    },
    link: function(scope, elem, attrs) {
      var emptyMessage, form, _i, _len, _ref, _results;
      if (emptyMessage === "") {
        emptyMessage = "You have no tasks in this list.";
      }
      if (attrs.customForm != null) {
        _ref = elem.find('form');
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          form = _ref[_i];
          if (form.className.match(/default-form/)) {
            form.remove();
            break;
          } else {
            _results.push(void 0);
          }
        }
        return _results;
      }
    }
  };
});
