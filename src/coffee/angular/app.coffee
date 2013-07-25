# Declare app level module which depends on filters, and services

angular
  .module('influences', ['influences.filters', 'influences.services', 'influences.directives', 'influences.controllers'])
  .config(['$routeProvider', ($routeProvider)->
    $routeProvider.when('/individual', {templateUrl: 'partials/individual.html', controller: 'IndividualCtrl'})
    $routeProvider.when('/bill', {templateUrl: 'partials/bill.html', controller: 'BillCtrl'})
    $routeProvider.otherwise({redirectTo: '/individual'})
  ])
  # set default headers to cors for api access to sunlight foundation
  .config(['$httpProvider', ($httpProvider) ->
    $httpProvider.defaults.useXDomain = true
    delete $httpProvider.defaults.headers.common['X-Requested-With']
  ])