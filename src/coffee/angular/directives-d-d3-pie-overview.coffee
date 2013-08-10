###########################
# d3 pie chart overview   #
###########################
angular
  .module('influences.directives')
  .directive('d3PieChartOverview', ['$rootScope', 'To_pretty', ($rootScope, To_pretty)->

    # init services
    num_to_dollars = To_pretty.num_to_dollars

    restrict: 'E'
    scope:
      data: '='

    link: (scope, element, attrs)->
      svg = d3.select(element[0])
        .append("svg")
        .attr("width", "100%")

      # on window resize, redraw d3 canvas
      scope.$watch( (()-> angular.element(window)[0].innerWidth), ((newValue, oldValue)-> scope.drawD3()) )
      window.onresize = (()-> scope.$apply())

      scope.drawD3 = ()->
        scope.$watch 'data', (newVals, oldVals)->
          # when the data set changes remove everything from the svg
          svg.selectAll('*').remove()
          if not newVals
            return  # if there is no data after the val is changed

          # munging data
          total = _.reduce(newVals, ((sum, data)-> sum + parseInt(data.amount)), 0)
          radius = (d3.select(element[0])[0][0].offsetWidth) / 2

          # set a function to return a color
          color = d3.scale.ordinal()
            .range(["#98abc5", "#8a89a6", "#7b6888", "#6b486b", "#a05d56", "#d0743c", "#ff8c00"])

          # create a div for the tooltip
          tooltip_div = d3.select(element[0]).append("div")
            .attr("class", "tooltip tooltip_pie")
            .style("opacity", 1e-6)

          # set the dimensions of the donut chart
          arc = d3.svg.arc()
            .outerRadius(radius - 5)
            .innerRadius(radius * 5/12)

          # give the data to the pie function to make each piece
          pie = d3.layout.pie()
            .sort(null)
            .value( ((d)-> d.amount) )

          # create a canvas to paint on in the center of the svg
          canvas = svg
            .attr("height", radius*2)
            .append("g")
            .attr("transform", "translate(" + radius + "," + radius + ")")

          # make group for pie piece and label text, add mouseover events to the group
          g = canvas.selectAll(".arc")
            .data( pie(newVals) )
            .enter()
              .append("g")
              .attr("class", "arc")
              .on("mouseover", (()-> tooltip_div.transition().style("opacity", 1)) )
              .on("mousemove", (d, i)->
                tooltip_div
                .style("left", (d3.event.pageX) + "px")
                .style("top", (d3.event.pageY) + "px")
                .html("Sector: #{d.data.name}<br />Amount: <strong>#{num_to_dollars(d.data.amount)}</strong><br />Number of Contributions: #{d.data.count}")
              )
              .on("click", (d, i)->
                scope.$apply($rootScope.selected.industry = scope.$parent.industry.top[i])
                scope.$parent.modal_open 'reps_by_industry'
                $rootScope.selected.rep1 = {}
              )
              .on("mouseout", (()-> tooltip_div.transition().style("opacity", 1e-6)) )

          # add pie pieces
          g.append("path")
            .attr("d", arc)
            .style("fill", "white")
            .transition()
              .duration(1000)
              .style("fill", ((d, i)-> color(i)) )

          # add pie piece labels
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
            .attr("dx", -((radius-10) - (radius * 5/12))/2 )
            .style("text-anchor", "start")
            .text( (d, i)->
              if i < 40
                d.data.name
            )

          # clip overflow of label text in middle
          canvas.append("circle")
            .attr("r", radius * 5/12 - 1)
            .style("fill", "white")
            .attr("class", "clip")

          # clip overflow text outside of pie
          cliparc = d3.svg.arc()
            .innerRadius(radius - 5)
            .outerRadius(radius + 100)
            .startAngle(0)
            .endAngle(2 * Math.PI)

          canvas.append("path")
            .attr("class", "clip")
            .attr("d", cliparc)
            .style("fill", "white")

          # append middle label
          canvas.append("text")
            .style("text-anchor", "middle")
            .attr("dy", ".35em")
            .attr("font-size", "large")
            .text(num_to_dollars(total))

      # initial run
      scope.drawD3()
  ])
