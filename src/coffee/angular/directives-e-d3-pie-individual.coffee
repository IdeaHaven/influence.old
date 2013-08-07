###########################
# d3 pie chart individual #
###########################
angular
  .module('influences.directives')
  .directive('d3PieChartIndividual', [()->

    restrict: 'E'
    scope:
      data: '='

    link: (scope, element, attrs)->
      canvas_containger = d3.select(element[0])
        .append("svg")
        .attr("width", "100%")

      # on window resize, redraw d3 canvas
      scope.$watch( (()-> angular.element(window)[0].innerWidth), ((newValue, oldValue)-> scope.drawD3()) )
      window.onresize = (()-> scope.$apply())

      scope.drawD3 = ()->
        scope.$watch 'data', (newVals, oldVals)->
          canvas_containger.selectAll('*').remove()
          if not newVals
            return  # if there is no data after the val is changed

          # munging data
          munged_data = [{"Donators": newVals[attrs.property0][0], "Amount": newVals[attrs.property0][1] },{"Donators": newVals[attrs.property1][0], "Amount": newVals[attrs.property1][1] }]
          total = _.reduce(munged_data, ((sum, data)-> sum + parseInt(data.Amount)), 0)
          radius = (d3.select(element[0])[0][0].offsetWidth) / 2

          color = d3.scale.ordinal()
            .range(["#98abc5", "#8a89a6", "#7b6888", "#6b486b", "#a05d56", "#d0743c", "#ff8c00"])

          arc = d3.svg.arc()
            .outerRadius(radius - 5)
            .innerRadius(radius * 5/12)

          pie = d3.layout.pie()
            .sort(null)
            .value( ((d)-> d.Amount) )

          canvas = canvas_containger
            .attr("height", radius*2)
            .append("g")
            .attr("transform", "translate(" + radius + "," + radius + ")")

          g = canvas.selectAll(".arc")
            .data( pie(munged_data) )
            .enter()
              .append("g")
              .attr("class", "arc")

          g.append("path")
            .attr("d", arc)
            .style("fill", "white")
            .transition()
              .duration(1000)
              .style("fill", ((d, i)-> color(i)) )

          g.append("text")
            .attr("transform", ((d, i)-> "translate(" + arc.centroid(d) + ")") )
            .attr("dy", ".35em")
            .style("text-anchor", "middle")
            .text( ((d, i)-> attrs["property#{i}"]) )

          g.append("text")
            .attr("transform", "translate(#{-1 * radius / 5},5)")
            .text("$#{Math.round(total).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",")}")

      # initial run
      scope.drawD3()
  ])
