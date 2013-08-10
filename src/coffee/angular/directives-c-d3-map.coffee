################
# d3 map       #
################
angular
  .module('influences.directives')
  .directive('d3Map', ['$rootScope' , ($rootScope)->

    restrict: 'E'
    scope:
      data: '='

    link: (scope, element, attrs)->

      # on window resize, redraw d3 canvas
      scope.$watch( (()-> angular.element(window)[0].innerWidth), ((newValue, oldValue)-> scope.draw_map()) )
      window.onresize = (()-> scope.$apply())

      # creat the svg and append to dom
      svg = d3.select("#map_holder")
        .append('svg')
        .append('g')

      # init the albersUsa projection and path
      projection = d3.geo.albersUsa().scale(1100)
      path = d3.geo.path().projection(projection)

      # create a div for the tooltip
      tooltip_div = d3.select(element[0]).append("div")
        .attr("class", "tooltip tooltip_map")
        .style("opacity", 1e-6)

      # add data to svg with events
      d3.json "../data/us-states.json", (error, data)->
        svg.selectAll(".states")
            .data(topojson.object(data, data.objects.states).geometries)
          .enter().append("path")
            .attr("class", "states")
            .attr("d", path)
            .style("fill", "#aaa")
            .on("mouseover", (d, i)->
              tooltip_div.transition().style("opacity", 1)
              d3.select(this).style("fill", "blue")
            )
            .on("mousemove", (d, i)->
              tooltip_div
                .style("left", (d3.event.pageX) + "px")
                .style("top", (d3.event.pageY) + "px")
                .html("tooltip text here")
            )
            # .on("click", (d, i)->
            #   console.log this
            #   # scope.$apply($rootScope.selected.state = )
            # )
            .on("mouseout", ()->
              tooltip_div.transition().style("opacity", 1e-6)
              d3.select(this).style("fill", "#aaa")
            )


      # draw the map based on the current width
      scope.draw_map = ()->
        # get the current width of the div
        width = parseInt(d3.select("#map_holder").style('width'))

        # transform the states to scale to the width
        d3.select("g")
          .attr("transform", "scale(#{width/900})")

        # update the svg height based on the new width
        d3.select("svg")
          .attr 'height', width*0.618

      # init the map for the first time
      scope.draw_map()
  ])
