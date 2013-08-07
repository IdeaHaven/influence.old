angular
  .module('influences.controllers')
  .controller('OverviewCtrl', ['$rootScope', '$scope', 'Api_get', ($rootScope, $scope, Api_get)->

######################
# Variable Setup
######################

    # these were defined in AppCtrl and $scope will delegate to $rootScope
      # $rootScope.reps
      # $rootScope.selected
      # $rootScope.reps_names_list

    # init local variable
    $scope.loaded = {industry_top: false}
    $scope.get = {}
    $scope.callback = {}

######################
# Define API Methods
######################

    $scope.get.top_industries = ()->  # there are 82 for year 2012, if changing year check to ensure all are downloaded
      Api_get.influence "aggregates/industries/top_100.json?cycle=2012&", $scope.callback.top_industries, this

    $scope.callback.top_industries = (error, data)->
      if not error
        $scope.industry = $scope.industry or {}
        $scope.industry.top = data.json
        $scope.loaded.industry_top = true
      else console.log "Error: ", error

    $scope.get.reps_by_zip = ()->
      Api_get.congress "legislators/locate?zip=#{$scope.selected.zip}", $scope.callback.reps_by_zip, this

    $scope.callback.reps_by_zip = (error, data)->
      if not error
        $scope.reps_by_zip = []
        for rep in data
          rep.fullname = "#{rep.title}. #{rep.first_name} #{rep.last_name}"
          $scope.reps_by_zip.push({name: rep.fullname, bioguide_id: rep.bioguide_id})
      else console.log "Error: ", error

######################
# Define UI Methods
######################


######################
# Initial Method Calls
######################

    # initial function calls
    $scope.$watch 'selected.zip', $scope.get.reps_by_zip
    $scope.get.top_industries()

  ])
