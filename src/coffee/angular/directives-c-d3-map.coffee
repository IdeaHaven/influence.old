################
# d3 map       #
################
angular
  .module('influences.directives')
  .directive('d3Map', [()->

    restrict: 'E'
    scope:
      data: '='

    link: (scope, element, attrs)->

      # on window resize, redraw d3 canvas
      # scope.$watch( (()-> angular.element(window)[0].innerWidth), ((newValue, oldValue)-> scope.albersMap()) )
      # window.onresize = (()-> scope.$apply())

      d3.select(window).on("resize", sizeChange)

      projection = d3.geo.albersUsa().scale(1100)

      path = d3.geo.path().projection(projection)

      svg = d3.select("#mapHolder")
        .append('svg')
        .append('g')

      d3.json "../data/us-states.json", (error, us)->
        svg.selectAll(".states")
            .data(topojson.object(us, us.objects.states).geometries)
          .enter().append("path")
            .attr("class", "states")
            .attr("d", path)

      sizeChange = ()->
        width = parseInt(d3.select("#mapHolder").style('width'))
        d3.select("g")
          .attr("transform", "scale(#{width/900})")
        angular.element(window)[0].innerWidth
        d3.select("svg")
          .attr 'height', width*0.618
      sizeChange()
  ])
