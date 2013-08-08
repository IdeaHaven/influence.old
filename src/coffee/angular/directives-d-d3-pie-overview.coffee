###########################
# d3 pie chart overview   #
###########################
angular
  .module('influences.directives')
  .directive('d3PieChartOverview', [($rootScope)->

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
          total = _.reduce(newVals, ((sum, data)-> sum + parseInt(data.amount)), 0)
          radius = (d3.select(element[0])[0][0].offsetWidth) / 2

          color = d3.scale.ordinal()
            .range(["#98abc5", "#8a89a6", "#7b6888", "#6b486b", "#a05d56", "#d0743c", "#ff8c00"])

          div = d3.select(element[0]).append("div")
            .attr("class", "tooltip")
            .style("opacity", 1e-6)

          arc = d3.svg.arc()
            .outerRadius(radius - 5)
            .innerRadius(radius * 5/12)

          pie = d3.layout.pie()
            .sort(null)
            .value( ((d)-> d.amount) )

          canvas = canvas_containger
            .attr("height", radius*2)
            .append("g")
            .attr("transform", "translate(" + radius + "," + radius + ")")

          g = canvas.selectAll(".arc")
            .data( pie(newVals) )
            .enter()
              .append("g")
              .attr("class", "arc")
              .on("mouseover", (()-> div.transition().style("opacity", 1)) )
              .on("mousemove", (d, i)->
                div
                .style("left", (d3.event.pageX) + "px")
                .style("top", (d3.event.pageY) + "px")
                .html("Sector: #{d.data.name}<br />Amount: <strong>$#{Math.round(d.data.amount).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",")}</strong><br />Number of Contributions: #{d.data.count}")
              )
              .on("click", (d, i)->
                scope.$apply(scope.$parent.selected.industry = scope.$parent.industry.top[i])
                scope.$parent.modal_open 'reps_by_industry'
              )
              .on("mouseout", (()-> div.transition().style("opacity", 1e-6)) )

          g.append("path")
            .attr("d", arc)
            .style("fill", "white")
            .transition()
              .duration(1000)
              .style("fill", ((d, i)-> color(i)) )


          g.append("text")
            .attr("transform", (d, i)->
              angle = ()->
                a = (d.startAngle + d.endAngle) * 90 / Math.PI - 90
                if a > 90
                  return a-180
                else
                  return a
              "translate(#{arc.centroid(d)})rotate(#{angle()})"
            )
            .attr("font-size", "x-small")
            .attr("dy", ".35em")
            .style("text-anchor", "middle")
            .text( (d, i)->
              if i < 40
                d.data.name
            )

          g.append("text")
            .attr("transform", "translate(#{-1 * radius / 4}, 10)")
            .attr("font-size", "x-large")
            .text("$#{Math.round(total).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",")}")

      # initial run
      scope.drawD3()
  ])
