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
      canvas = d3.select(element[0])
        .append("svg")
        .attr("width", 300)
        .attr("height", 350)

      # on window resize, redraw d3 canvas
      scope.$watch( (()-> angular.element(window)[0].innerWidth), ((newValue, oldValue)-> scope.drawD3()) )
      window.onresize = (()-> scope.$apply())

      scope.drawD3 = ()->
        group = canvas.append('g')
        projection = d3.geo.albersUsa()
        group.attr('transorm', 'scale(.3, .3)')

        d3.json('../data/us-states.json', (collection)->
          group.selectAll('path')
            .data(collection.features)
          .enter().append('path')
            .attr('d', d3.geo.path().projection(projection))
            .attr('id', (d)->
              d.properties.name.replace(/\s+/g, ''))
            .style('fill', 'gray')
            .style('stroke', 'white')
            .style('stroke-width', 1))
      scope.drawD3()
  ])
