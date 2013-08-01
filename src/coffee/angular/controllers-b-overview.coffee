# Controllers

angular
  .module('influences.controllers')
  .controller('OverviewCtrl', ['$scope', 'Api_get', ($scope, Api_get)->

    get_top_industries_by_amount = ()->  # there are 82 for year 2012, if changing year check to ensure all are downloaded
      Api_get.influence "aggregates/industries/top_100.json?cycle=2012", callback_top_industries_by_amount

    callback_top_industries_by_amount = (data)->
      $scope.top_industries = data.json

    # initial function calls
    get_top_industries_by_amount()

  ])
