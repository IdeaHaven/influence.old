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
        $scope.loaded[rep].transparencydata_id = true
        $scope.loaded.transparencydata_id_check()
      else console.log "Error: ", error

    $scope.get.bills = ()->
      Api_get.congress "bills?sponsor_id__in=#{$scope.selected_rep1.overview.bioguide_id}|#{$scope.selected_rep2.overview.bioguide_id}&cosponsor_ids__in=#{$scope.selected_rep1.overview.bioguide_id}|#{$scope.selected_rep2.overview.bioguide_id}&per_page=50", $scope.callback.bills, this

    $scope.callback.bills = (error, data)->
      if not error
        if _.isEmpty(data)
          data = [{official_title: "We found no bills in common while comparing the top 100 active bills sponsored by either representative"}]
        $scope.comparison = {bills: data}
        $scope.loaded.bills = true
      else console.log "Error: ", error

    $scope.get.contributors = ()->
      Api_get.influence "aggregates/pol/#{$scope.selected_rep1.transparencydata_id}/contributors.json?cycle=2012&limit=100&", $scope.callback.contributors, this, "selected_rep1"
      Api_get.influence "aggregates/pol/#{$scope.selected_rep2.transparencydata_id}/contributors.json?cycle=2012&limit=100&", $scope.callback.contributors, this, "selected_rep2"

    $scope.callback.contributors = (error, data, rep)->
      if not error
        $scope[rep].funding = $scope[rep].funding or {}
        $scope[rep].funding.contributors = data.json
        $scope.loaded[rep].contributors = true
        $scope.loaded.contributors_check()
      else console.log "Error: ", error

#####################
# Data Analysis
#####################

    $scope.analysis = {}

    $scope.analysis.contributors = ()->
      comp = {}
      both = []
      _.each($scope.selected_rep1.funding.contributors, ((val, index)-> comp[val.id] = index ))
      _.each($scope.selected_rep2.funding.contributors, (val, index)->
        if comp.hasOwnProperty(val.id)
          # some values have null as the id, this will verify a name check
          if val.name is $scope.selected_rep1.funding.contributors[comp[val.id]].name
            both.push  #[index, comp[val.id]]
              id: val.id
              name: val.name
              rep2:
                direct_amount: val.direct_amount
                direct_count: val.direct_count
                employee_amount: val.employee_amount
                employee_count: val.employee_count
                total_amount: val.total_amount
                total_count: val.total_count
                total: "$ " + Math.round(val.total_amount).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",")
              rep1:
                direct_amount: $scope.selected_rep1.funding.contributors[comp[val.id]].direct_amount
                direct_count: $scope.selected_rep1.funding.contributors[comp[val.id]].direct_count
                employee_amount: $scope.selected_rep1.funding.contributors[comp[val.id]].employee_amount
                employee_count: $scope.selected_rep1.funding.contributors[comp[val.id]].employee_count
                total_amount: $scope.selected_rep1.funding.contributors[comp[val.id]].total_amount
                total_count: $scope.selected_rep1.funding.contributors[comp[val.id]].total_count
                total: "$ " + Math.round($scope.selected_rep1.funding.contributors[comp[val.id]].total_amount).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",")
      )
      if _.isEmpty(both)
        both = [{name: "We found no contributors in common while comparing the top 100 contributors with donations over $1000"}]
      $scope.comparison.contributors = both
      $scope.loaded.contributors = true

#####################
# Define Watchers
#####################

    $scope.set_watchers_for_bioguide_id = _.once(()->
      $scope.$watch 'selected.rep1', $scope.get.bioguidedata
      $scope.$watch 'selected.rep2', $scope.get.bioguidedata
    )

    $scope.set_watchers_for_transparencydata_id = _.once(()->
      $scope.$watch 'selected_rep1', $scope.get.transparencydata
      $scope.$watch 'selected_rep2', $scope.get.transparencydata
    )

    $scope.get.bioguidedata = ()->
      $scope.loaded.reset_all()
      $scope.comparison = {}  # reset old comparison data
      $scope.selected_rep1 = $scope.reps[$scope.selected.rep1.bioguide_id] # set rep1 to object from root scope
      $scope.selected_rep2 = $scope.reps[$scope.selected.rep2.bioguide_id] # set rep2 to object from root scope
      $scope.get.transparencydata_id()
      $scope.get.bills()

    $scope.get.transparencydata = ()->
      $scope.get.contributors()

#####################
# Loading Checks
#####################

    $scope.loaded =
      selected_rep1: {}
      selected_rep2: {}
      reset_all: ()->
        $scope.loaded.selected_rep1.transparencydata_id = false
        $scope.loaded.selected_rep1.contributors = false
        $scope.loaded.selected_rep2.transparencydata_id = false
        $scope.loaded.selected_rep2.contributors = false
        $scope.loaded.transparencydata_id = false
        $scope.loaded.bills = false
        $scope.loaded.contributors = false

    $scope.loaded.reset_all()

    $scope.loaded.contributors_check = ()->
      if $scope.loaded.selected_rep1.contributors and $scope.loaded.selected_rep2.contributors
        $scope.analysis.contributors()

    $scope.loaded.transparencydata_id_check = ()->
      if $scope.loaded.selected_rep1.transparencydata_id and $scope.loaded.selected_rep2.transparencydata_id
        $scope.get.transparencydata()
        $scope.set_watchers_for_transparencydata_id()


#####################
# Initialize
#####################

    $scope.check_if_rep_data_loaded = ()->
      if _.isEmpty($scope.reps)
        $timeout($scope.check_if_rep_data_loaded, 500)
      else
        $scope.selected.rep1 = $scope.selected.rep1 or {name: "Rep. John Boehner", bioguide_id: "B000589"}
        $scope.selected.rep2 = $scope.selected.rep2 or {name: "Rep. Nanci Pelosi", bioguide_id: "P000197"}
        $scope.set_watchers_for_bioguide_id()

    # init
    $scope.check_if_rep_data_loaded()

  ])
