################
# d3 bar chart #
################
angular
  .module('influences.directives')
  .directive('d3BarChart', [()->

    restrict: 'E'
    scope:
      data: '='

    link: (scope, element, attrs)->
      canvas = d3.select(element[0])
        .append("svg")
        .attr("width", "100%")
        .attr("height", 300) # 10 items x 30px height each

      # on window resize, redraw d3 canvas
      scope.$watch( (()-> angular.element(window)[0].innerWidth), ((newValue, oldValue)-> scope.drawD3()) )
      window.onresize = (()-> scope.$apply())

      scope.drawD3 = ()->
        scope.$watch 'data', (newVals, oldVals)->
          canvas.selectAll('*').remove()
          if not newVals
            return  # if there is no data after the val is changed

          # find width and max for scaling
          width = d3.select(element[0])[0][0].offsetWidth
          max = Math.max.apply(Math, _.map(newVals, ((val)-> val[attrs.number])))

          canvas.selectAll('rect')
            .data(newVals)
            .enter()
              .append("rect")
              .attr("fill", "DarkSalmon")
              .attr("height", 26)
              .attr("width", 0)
              .attr("y", ((d, i)-> i * 30) )
              .transition()
                .duration(1000)
                .attr("width", ((d)-> d[attrs.number] / (max/width)) )

          canvas.selectAll('text')
            .data(newVals)
            .enter()
              .append("text")
              .attr("fill", "Black")
              .attr("y", ((d, i)-> i * 30 + 18) )
              .attr("x", 10)
              .text( ((d)-> "$#{Math.round(d[attrs.number]).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");}: #{d[attrs.text]}") )

      # initial run
      scope.drawD3()
  ])
