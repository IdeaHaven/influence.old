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
    $scope.loaded =
      industry_top: false
      industry_to_reps: false
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

    $scope.get.reps_by_industry = ()->
      Api_get.influence "aggregates/org/#{$scope.selected.industry.id}/recipients.json?cycle=2012&limit=25&", $scope.callback.reps_by_industry, this

    $scope.callback.reps_by_industry = (error, data)->
      if not error
        $scope.industry = $scope.industry or {}
        for industry in data.json
          industry.total = '$' + Math.round(industry.total_amount).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",")
        $scope.industry.to_reps = data.json
        $scope.loaded.industry_to_reps = true
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

    $scope.set = {}

    $scope.set.rep_by_zip = (rep)->
      $scope.selected.rep1 = rep

#####################
# Define Modals and Options
#####################

    $scope.modal_should_be_open = {}

    $scope.modal_open = (modal)->
      $scope.$apply($scope.modal_should_be_open[modal] = true)

    $scope.modal_close = (modal)->
      $scope.modal_should_be_open[modal] = false

    $scope.modal_options =
      backdropFade: true
      dialogFade:true

######################
# Initial Method Calls
######################

    # initial function calls
    $scope.$watch 'selected.zip', $scope.get.reps_by_zip
    $scope.$watch 'selected.industry', $scope.get.reps_by_industry
    $scope.get.top_industries()

  ])
