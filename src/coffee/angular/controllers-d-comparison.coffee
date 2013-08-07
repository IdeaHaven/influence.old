# Controllers

angular
  .module('influences.controllers')
  .controller('ComparisonCtrl', ['$rootScope', '$scope', 'Api_get', '$timeout', ($rootScope, $scope, Api_get, $timeout)->

#####################
#Define API Methods
#####################

    $scope.get = {}
    $scope.callback = {}

    $scope.get.transparencydata_id = ()->
      Api_get.influence "entities/id_lookup.json?bioguide_id=#{$scope.selected_rep1.overview.bioguide_id}&", $scope.callback.transparencydata_id, this, "selected_rep1"
      Api_get.influence "entities/id_lookup.json?bioguide_id=#{$scope.selected_rep2.overview.bioguide_id}&", $scope.callback.transparencydata_id, this, "selected_rep2"

    $scope.callback.transparencydata_id = (error, data, rep)->
      if not error
        $scope[rep].transparencydata_id = data.id

        run_once = run_once or false
        if not run_once
          $scope.set_watchers_for_transparencydata_id() # only set the watchers once
          run_once = true
      else console.log "Error: ", error

    $scope.get.bills = ()->
      Api_get.congress "bills?sponsor_id__in=#{$scope.selected_rep1.overview.bioguide_id}|#{$scope.selected_rep2.overview.bioguide_id}&cosponsor_ids__in=#{$scope.selected_rep1.overview.bioguide_id}|#{$scope.selected_rep2.overview.bioguide_id}&per_page=50", $scope.callback.bills, this

    $scope.callback.bills = (error, data)->
      if not error
        $scope.comparison = {bills: data}
        $scope.loaded.bills = true
      else console.log "Error: ", error

    $scope.get.contributors = ()->
      Api_get.influence "aggregates/pol/#{$scope.selected_rep1.transparencydata_id}/contributors.json?cycle=2012&limit=10&", $scope.callback.contributors, this, "selected_rep1"
      Api_get.influence "aggregates/pol/#{$scope.selected_rep2.transparencydata_id}/contributors.json?cycle=2012&limit=10&", $scope.callback.contributors, this, "selected_rep2"

    $scope.callback.contributors = (error, data, rep)->
      if not error
        $scope[rep].funding = $scope[rep].funding or {}
        $scope[rep].funding.contributors = data.json
        $scope.loaded[rep].contributors = true
      else console.log "Error: ", error

#####################
# Define Watchers
#####################

    $scope.set_watchers_for_bioguide_id = ()->
      $scope.$watch 'selected_rep1', $scope.get.transparencydata_id
      $scope.$watch 'selected_rep2', $scope.get.transparencydata_id
      $scope.$watch 'selected_rep1', $scope.loaded.reset
      $scope.$watch 'selected_rep2', $scope.loaded.reset
      $scope.$watch 'selected_rep1', $scope.get.bills
      $scope.$watch 'selected_rep2', $scope.get.bills
      # $scope.$watch 'selected_rep', $scope.get.bills_sponsored
      # $scope.$watch 'selected_rep', $scope.get.bills_cosponsored
      # $scope.$watch 'selected_rep', $scope.get.words

    $scope.set_watchers_for_transparencydata_id = ()->
      $scope.$watch 'selected_rep1', $scope.get.contributors
      $scope.$watch 'selected_rep2', $scope.get.contributors
      # $scope.$watch 'selected_rep.transparencydata_id', $scope.get.bio
      # $scope.$watch 'selected_rep.transparencydata_id', $scope.get.contributors
      # $scope.$watch 'selected_rep.transparencydata_id', $scope.get.industries
      # $scope.$watch 'selected_rep.transparencydata_id', $scope.get.sectors
      # $scope.$watch 'selected_rep.transparencydata_id', $scope.get.locale
      # $scope.$watch 'selected_rep.transparencydata_id', $scope.get.type

#####################
# Loading Checks
#####################

    $scope.loaded =
      bills: false
      selected_rep1:
        contributors: false
      selected_rep2:
        contributors: false
      contributors: false
      contributors_check: ()->
        if $scope.loaded.selected_rep1.contributors and $scope.loaded.selected_rep2.contributors
          $scope.loaded.contributors = true

#####################
# Initialize
#####################

    $scope.check_if_rep_data_loaded = ()->
      if _.isEmpty($scope.reps)
        $timeout($scope.check_if_rep_data_loaded, 500)
      else
        $scope.set_watchers_for_bioguide_id()
        $scope.selected_rep1 = $scope.reps[$scope.selected.rep1.bioguide_id] # set rep1 to object from global scope
        $scope.selected_rep2 = $scope.reps[$scope.selected.rep2.bioguide_id] # set rep1 to object from global scope

    # init check for rep data, check for a selected rep, watch for changes to selected rep, init scope variables
    $scope.check_if_rep_data_loaded()
    $scope.selected.rep1 = $scope.selected.rep1 or {name: "Rep. John Boehner", bioguide_id: "B000589"}
    $scope.selected.rep2 = $scope.selected.rep2 or {name: "Rep. Nanci Pelosi", bioguide_id: "P000197"}
    $scope.$watch 'selected.rep1', $scope.check_if_rep_data_loaded
    $scope.$watch 'selected.rep2', $scope.check_if_rep_data_loaded

  ])
