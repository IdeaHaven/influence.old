# Directives

angular
  .module('influences.directives', [])
  .directive('appVersion', ['version', (version)->
    (scope, elm, attrs)->
      elm.text(version)
  ])
  .directive('subView', [()->
    restrict: 'A'
    # this requires at least angular 1.1.4 (currently unstable)
    templateUrl: (notsurewhatthisis, attr)->
      "partials/#{attr.subView}.html"
  ])