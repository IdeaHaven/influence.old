# Directives

angular
  .module('influences.directives', [])
  .directive('appVersion', ['version', (version)->
    (scope, elm, attrs)->
      elm.text(version)
  ])
  .directive('subView', [()->
    restrict: 'E'
    # this requires at least angular 1.1.4 (currently unstable)
    templateUrl: (notsurewhatthisis, attrs)->
      "partials/#{attrs.template}.html"
  ])
  