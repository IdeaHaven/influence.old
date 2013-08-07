angular
  .module('influences', ['influences.filters', 'influences.services', 'influences.directives', 'influences.controllers'])
  .config(['$routeProvider', ($routeProvider)->
    $routeProvider.when('/overview', {templateUrl: 'partials/overview.html', controller: 'OverviewCtrl'})
    $routeProvider.when('/individual', {templateUrl: 'partials/individual.html', controller: 'IndividualCtrl'})
    $routeProvider.when('/comparison', {templateUrl: 'partials/comparison.html', controller: 'ComparisonCtrl'})
    $routeProvider.otherwise({redirectTo: '/overview'})
  ])
  # set default headers to cors for api access
  .config(['$httpProvider', ($httpProvider) ->
    $httpProvider.defaults.useXDomain = true
    delete $httpProvider.defaults.headers.common['X-Requested-With']
  ])