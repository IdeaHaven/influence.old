# Directives

angular
  .module('influences.directives', [])
  .directive('subView', [()->
    restrict: 'E'
    # this requires at least angular 1.1.4 (currently unstable)
    templateUrl: (element, attrs)->
      "partials/#{attrs.template}.html"
  ])
