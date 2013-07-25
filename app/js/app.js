(function() {
  angular.module('influences', ['influences.filters', 'influences.services', 'influences.directives', 'influences.controllers']).config([
    '$routeProvider', function($routeProvider) {
      $routeProvider.when('/view1', {
        templateUrl: 'partials/individual.html',
        controller: 'IndividualCtrl'
      });
      return $routeProvider.otherwise({
        redirectTo: '/view1'
      });
    }
  ]);

}).call(this);

(function() {
  angular.module('influences.controllers', []).controller('IndividualCtrl', [
    '$scope', function($scope) {
      return $scope.name = "hahah";
    }
  ]);

}).call(this);

(function() {
  angular.module('influences.directives', []).directive('appVersion', [
    'version', function(version) {
      return function(scope, elm, attrs) {
        return elm.text(version);
      };
    }
  ]);

}).call(this);

(function() {
  angular.module('influences.filters', []).filter('interpolate', [
    'version', function(version) {
      return function(text) {
        return String(text).replace(/\%VERSION\%/mg, version);
      };
    }
  ]);

}).call(this);

(function() {
  angular.module('influences.services', []).value('version', '0.1');

}).call(this);
