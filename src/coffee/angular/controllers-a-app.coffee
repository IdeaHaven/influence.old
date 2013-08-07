angular
  .module('influences.controllers', ['ui.bootstrap', 'influences.services'])
  .controller('NavCtrl', ['$scope', '$location', ($scope, $location)->
    $scope.navClass = (page)->
      if page is $location.path().substring(1) then 'active' else ''
  ])
  .controller('AppCtrl', ['$rootScope', '$scope', 'version', 'attribution', 'Api_get', ($rootScope, $scope, version, attribution, Api_get)->
    # init global variables for all controllers to use
    $rootScope.reps = {}
    $rootScope.selected = {rep1: null, rep2: null, zip: null, company: null, sector: null, industry: null}
    $rootScope.reps_names_list = []

    $scope.get_all_reps_in_office = ()->
      Api_get.congress "/legislators?per_page=all", $scope.callback_all_reps_in_office, this

    $scope.callback_all_reps_in_office = (error, data)->
      if not error
        for rep in data
          rep.fullname = "#{rep.title}. #{rep.first_name} #{rep.last_name}"
          $scope.reps_names_list.push({name: rep.fullname, bioguide_id: rep.bioguide_id});
          rep.chamber = rep.chamber.charAt(0).toUpperCase() + rep.chamber.slice(1)  # cap first letter
          rep.party_name = if rep.party is "D" then "Democrat" else if rep.party is "R" then "Republican" else rep.party
          $scope.reps[rep.bioguide_id] = {}
          $scope.reps[rep.bioguide_id].overview = rep
      else
        console.log "Error: ", error

    $scope.get_all_reps_in_office()

    # get data from services
    $scope.version = version
    $scope.source = attribution.source
    $scope.license = attribution.license
  ])