# Controllers

angular
  .module('influences.controllers')
  .controller('IndividualCtrl', ['$rootScope', '$scope', 'Api_get', '$timeout', ($rootScope, $scope, Api_get, $timeout)->

    $scope.check_if_rep_data_loaded = ()->
      if _.isEmpty($scope.reps)
        $timeout($scope.check_if_rep_data_loaded, 500)
      else
        $scope.set_watchers_for_bioguide_id()
        $scope.selected_rep = $scope.reps[$scope.selected.rep1.bioguide_id] # set rep1 to object from global scope

    # init check for rep data, check for a selected rep, watch for changes to selected rep, init scope variables
    $scope.check_if_rep_data_loaded()
    $scope.selected.rep1 = $scope.selected.rep1 or {name: "Rep. John Boehner", bioguide_id: "B000589"}
    $scope.$watch 'selected.rep1', $scope.check_if_rep_data_loaded

    $scope.get = {}
    $scope.callback = {}


    # set default variables
    $scope.loaded =
      bio: false
      committees: false
      bills_sponsored: false
      bills_cosponsored: false
      modals: false
      modals_check: ()->
        if $scope.loaded.committees and $scope.loaded.bills_sponsored and $scope.loaded.bills_cosponsored
          $scope.loaded.modals = true
      contributors: false
      industries: false
      sectors: false
      locale: false
      type: false
      words: false
      reset: ()->
        $scope.loaded.bio = false
        $scope.loaded.committees = false
        $scope.loaded.bills_sponsored = false
        $scope.loaded.bills_cosponsored = false
        $scope.loaded.modals = false
        $scope.loaded.contributors = false
        $scope.loaded.industries = false
        $scope.loaded.sectors = false
        $scope.loaded.locale = false
        $scope.loaded.type = false
        $scope.loaded.words = false
    $scope.$watch 'loaded.bills_committees', $scope.loaded.modals_check
    $scope.$watch 'loaded.bills_sponsored', $scope.loaded.modals_check
    $scope.$watch 'loaded.bills_cosponsored', $scope.loaded.modals_check

#####################
#Define API Methods
#####################

    $scope.get.transparencydata_id = ()->
      Api_get.influence "entities/id_lookup.json?bioguide_id=#{$scope.selected_rep.overview.bioguide_id}&", $scope.callback.transparencydata_id, this

    $scope.callback.transparencydata_id = (error, data)->
      if not error
        $scope.selected_rep.transparencydata_id = data.id

        run_once = run_once or false
        if not run_once
          $scope.set_watchers_for_transparencydata_id() # only set the watchers once
          run_once = true
      else console.log "Error: ", error

    $scope.get.bio = ()->
      Api_get.influence "entities/#{$scope.selected_rep.transparencydata_id}.json?", $scope.callback.bio, this

    $scope.callback.bio = (error, data)->
      if not error
        $scope.selected_rep.bio = data
        console.log data
        $scope.loaded.bio = true
      else console.log "Error: ", error

    $scope.get.committees = ()->
      if not $scope.selected_rep.overview.leadership_role  # no committees if a leader
        $scope.selected_rep.overview.leader = false
        if not $scope.selected_rep.committees  # if committees were already pulled, don't pull again
          Api_get.congress "committees?member_ids=#{$scope.selected_rep.overview.bioguide_id}", $scope.callback.committees
      else
        $scope.selected_rep.overview.leader = true
        $scope.loaded.committees = true

    $scope.callback.committees = (error, data)->
      if not error
        $scope.selected_rep.committees = data
        $scope.loaded.committees = true
      else console.log "Error: ", error

    $scope.get.bills_sponsored = ()->
      if not $scope.selected_rep.bills
        Api_get.congress "bills?history.active=true&sponsor_id=#{$scope.selected_rep.overview.bioguide_id}", $scope.callback.bills_sponsored, this

    $scope.callback.bills_sponsored = (error, data)->
      if not error
        $scope.selected_rep.bills = $scope.selected_rep.bills or []
        for bill in data
          if not bill.short_title
            bill.short_title = bill.official_title
        $scope.selected_rep.bills.sponsored = data
        $scope.loaded.bills_sponsored = true
      else console.log "Error: ", error

    $scope.get.bills_cosponsored = ()->
      if not $scope.selected_rep.bills
        Api_get.congress "bills?history.active=true&cosponsor_ids=#{$scope.selected_rep.overview.bioguide_id}", $scope.callback.bills_cosponsored, this

    $scope.callback.bills_cosponsored = (error, data)->
      if not error
        $scope.selected_rep.bills = $scope.selected_rep.bills or []
        for bill in data
          if not bill.short_title
            bill.short_title = bill.official_title
        $scope.selected_rep.bills.cosponsored = data
        $scope.loaded.bills_cosponsored = true
      else console.log "Error: ", error

    $scope.get.contributors = ()->
      Api_get.influence "aggregates/pol/#{$scope.selected_rep.transparencydata_id}/contributors.json?cycle=2012&limit=10&", $scope.callback.contributors, this

    $scope.callback.contributors = (error, data)->
      if not error
        $scope.selected_rep.funding = $scope.selected_rep.funding or {}
        $scope.selected_rep.funding.contributors = data.json
        $scope.loaded.contributors = true
      else console.log "Error: ", error

    $scope.get.industries = ()->
      Api_get.influence "aggregates/pol/#{$scope.selected_rep.transparencydata_id}/contributors/industries.json?cycle=2012&limit=10&", $scope.callback.industries, this

    $scope.callback.industries = (error, data)->
      if not error
        $scope.selected_rep.funding = $scope.selected_rep.funding or {}
        $scope.selected_rep.funding.industries = data.json
        $scope.loaded.industries = true
      else console.log "Error: ", error

    $scope.get.sectors = ()->
      Api_get.influence "aggregates/pol/#{$scope.selected_rep.transparencydata_id}/contributors/sectors.json?cycle=2012&limit=10&", $scope.callback.sectors, this

    $scope.callback.sectors = (error, data)->
      names =
        F: "Finance/Insurance/Real Estate"
        W: "Other"
        N: "Misc Business"
        Q: "Ideology/Single-Issue"
        H: "Health"
        K: "Lawyers & Lobbyists"
        B: "Communications/Electronics"
        P: "Labor"
        E: "Energy/Natural Resources"
        C: "Construction"
        A: "Agribusiness"
        M: "Transportation"
        D: "Defense"

      if not error
        $scope.selected_rep.funding = $scope.selected_rep.funding or {}
        for sector in data.json
          sector.name = names[sector.sector]
        $scope.selected_rep.funding.sectors = data.json
        $scope.loaded.sectors = true
      else console.log "Error: ", error

    $scope.get.locale = ()->
      Api_get.influence "aggregates/pol/#{$scope.selected_rep.transparencydata_id}/contributors/local_breakdown.json?cycle=2012&limit=10&", $scope.callback.locale, this

    $scope.callback.locale = (error, data)->
      if not error
        $scope.selected_rep.funding = $scope.selected_rep.funding or {}
        $scope.selected_rep.funding.locale = data
        $scope.loaded.locale = true
      else console.log "Error: ", error

    $scope.get.type = ()->
      Api_get.influence "aggregates/pol/#{$scope.selected_rep.transparencydata_id}/contributors/type_breakdown.json?cycle=2012&limit=10&", $scope.callback.type, this

    $scope.callback.type = (error, data)->
      if not error
        $scope.selected_rep.funding = $scope.selected_rep.funding or {}
        $scope.selected_rep.funding.type = data
        $scope.loaded.type = true
      else console.log "Error: ", error

    $scope.get.words = ()->
      Api_get.words "phrases.json?entity_type=legislator&entity_value=B000589&page=0&sort=count%20desc", $scope.callback.words, this

    $scope.callback.words = (error, data)->
      if not error
        $scope.selected_rep.words = data.json
        $scope.loaded.words = true
      else console.log "Error: ", error

#####################
# Define Watchers
#####################

    $scope.set_watchers_for_bioguide_id = ()->
      $scope.$watch 'selected_rep', $scope.loaded.reset
      $scope.$watch 'selected_rep', $scope.get.transparencydata_id
      $scope.$watch 'selected_rep', $scope.get.committees
      $scope.$watch 'selected_rep', $scope.get.bills_sponsored
      $scope.$watch 'selected_rep', $scope.get.bills_cosponsored
      $scope.$watch 'selected_rep', $scope.get.words

    $scope.set_watchers_for_transparencydata_id = ()->
      $scope.$watch 'selected_rep.transparencydata_id', $scope.get.bio
      $scope.$watch 'selected_rep.transparencydata_id', $scope.get.contributors
      $scope.$watch 'selected_rep.transparencydata_id', $scope.get.industries
      $scope.$watch 'selected_rep.transparencydata_id', $scope.get.sectors
      $scope.$watch 'selected_rep.transparencydata_id', $scope.get.locale
      $scope.$watch 'selected_rep.transparencydata_id', $scope.get.type

#####################
# Define Modals and Options
#####################

    $scope.modal_should_be_open = {}

    $scope.modal_open = (modal)->
      $scope.modal_should_be_open[modal] = true

    $scope.modal_close = (modal)->
      $scope.modal_should_be_open[modal] = false

    $scope.modal_options =
      backdropFade: true
      dialogFade:true

  ])
