(function() {
  angular.module('influences', ['influences.filters', 'influences.services', 'influences.directives', 'influences.controllers']).config([
    '$routeProvider', function($routeProvider) {
      $routeProvider.when('/individual', {
        templateUrl: 'partials/individual.html',
        controller: 'IndividualCtrl'
      });
      $routeProvider.when('/bill', {
        templateUrl: 'partials/bill.html',
        controller: 'BillCtrl'
      });
      return $routeProvider.otherwise({
        redirectTo: '/individual'
      });
    }
  ]).config([
    '$httpProvider', function($httpProvider) {
      $httpProvider.defaults.useXDomain = true;
      return delete $httpProvider.defaults.headers.common['X-Requested-With'];
    }
  ]);

}).call(this);

(function() {
  angular.module('influences.controllers', []).controller('IndividualCtrl', [
    '$scope', '$http', function($scope, $http) {
      $http({
        url: "http://congress.api.sunlightfoundation.com/legislators/locate?zip=94404&apikey=83c0368c509f468e992218f41e6529d7",
        method: "GET"
      }).success(function(data, status, headers, config) {
        return $scope.data = data;
      }).error(function(data, status, headers, config) {
        return $scope.status = status;
      });
      return $scope.ind = {
        name: "hahah"
      };
    }
  ]).controller('BillCtrl', [
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
