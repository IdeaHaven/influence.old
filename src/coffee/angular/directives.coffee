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
  .directive('d3Funding', [()->
    margin = 20
    width = 400 - .5 - margin
    height = 400 - .5 - margin
    color = d3.interpolateRgb "#f77", "#77f"

    restrict: 'E'
    scope:
      val: '='
    link: (scope, element, attrs)->

      # setup d3 svg object
      canvas = d3.select(element[0])
        .append("svg")
        .attr("width", width)
        .attr("height", height)

      # scope.$watch 'val', (newVal, oldVal)->
      #   vis.selectAll('*').remove()
      #   if not newVal
      #     return

      circle = canvas.append("circle")
        .attr("cx", 50)
        .attr("cy", 50)
        .attr("r", 50)
        .attr("fill", "red")

      console.log scope.$parent.$parent


  ])