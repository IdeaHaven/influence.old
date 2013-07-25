# Declare app level module which depends on filters, and services

angular
  .module('influences', ['influences.filters', 'influences.services', 'influences.directives', 'influences.controllers'])
  .config(['$routeProvider', ($routeProvider)->
    $routeProvider.when('/view1', {templateUrl: 'partials/individual.html', controller: 'IndividualCtrl'})
    # $routeProvider.when('/view2', {templateUrl: 'partials/partial2.html', controller: 'MyCtrl2'})
    $routeProvider.otherwise({redirectTo: '/view1'})
  ])
