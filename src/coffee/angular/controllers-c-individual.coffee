angular
  .module('influences.controllers')
  .controller('IndividualCtrl', ['$rootScope', '$scope', 'Api_get', '$timeout', '$routeParams', ($rootScope, $scope, Api_get, $timeout, $routeParams)->

#####################
# Define API Methods
#####################

    $scope.get = {}
    $scope.callback = {}

    $scope.get.transparencydata_id = ()->
      if not $scope.loaded.trandparencydata_id
        Api_get.influence "entities/id_lookup.json?bioguide_id=#{$scope.selected_rep.overview.bioguide_id}&", $scope.callback.transparencydata_id, this

    $scope.callback.transparencydata_id = (error, data)->
      if not error
        $scope.selected_rep.transparencydata_id = data.id
        $scope.loaded.trandparencydata_id = true
        $scope.get.transparencydata()
        $scope.set_watchers_for_transparencydata_id()
      else console.log "Error: ", error

    $scope.get.bio = ()->
      if not $scope.loaded.bio
        Api_get.influence "entities/#{$scope.selected_rep.transparencydata_id}.json?", $scope.callback.bio, this

    $scope.callback.bio = (error, data)->
      if not error
        $scope.selected_rep.bio = data
        $scope.loaded.bio = true
      else console.log "Error: ", error

    $scope.get.committees = ()->
      if not $scope.selected_rep.overview.leadership_role  # no committees if a leader
        $scope.selected_rep.overview.leader = false
        if not $scope.loaded.committees
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
      if not $scope.loaded.bills_sponsored
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
      if not $scope.loaded.bills_cosponsored
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
      if not $scope.loaded.contributors
        Api_get.influence "aggregates/pol/#{$scope.selected_rep.transparencydata_id}/contributors.json?cycle=2012&limit=10&", $scope.callback.contributors, this

    $scope.callback.contributors = (error, data)->
      if not error
        $scope.selected_rep.funding = $scope.selected_rep.funding or {}
        $scope.selected_rep.funding.contributors = data.json
        $scope.loaded.contributors = true
      else console.log "Error: ", error

    $scope.get.industries = ()->
      if not $scope.loaded.industries
        Api_get.influence "aggregates/pol/#{$scope.selected_rep.transparencydata_id}/contributors/industries.json?cycle=2012&limit=10&", $scope.callback.industries, this

    $scope.callback.industries = (error, data)->
      if not error
        $scope.selected_rep.funding = $scope.selected_rep.funding or {}
        for industry in data.json
          industry.name = industry.name.toLowerCase()
          # industry.name = industry.name.splice()
        $scope.selected_rep.funding.industries = data.json
        $scope.loaded.industries = true
      else console.log "Error: ", error

    $scope.get.sectors = ()->
      if not $scope.loaded.sectors
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
      if not $scope.loaded.locale
        Api_get.influence "aggregates/pol/#{$scope.selected_rep.transparencydata_id}/contributors/local_breakdown.json?cycle=2012&limit=10&", $scope.callback.locale, this

    $scope.callback.locale = (error, data)->
      if not error
        $scope.selected_rep.funding = $scope.selected_rep.funding or {}
        $scope.selected_rep.funding.locale = data
        $scope.loaded.locale = true
      else console.log "Error: ", error

    $scope.get.type = ()->
      if not $scope.loaded.type
        Api_get.influence "aggregates/pol/#{$scope.selected_rep.transparencydata_id}/contributors/type_breakdown.json?cycle=2012&limit=10&", $scope.callback.type, this

    $scope.callback.type = (error, data)->
      if not error
        $scope.selected_rep.funding = $scope.selected_rep.funding or {}
        $scope.selected_rep.funding.type = data
        $scope.loaded.type = true
      else console.log "Error: ", error

    # $scope.get.words = ()->
    #   if not $scope.loaded.words
    #     Api_get.words "phrases.json?entity_type=legislator&entity_value=B000589&page=0&sort=count%20desc", $scope.callback.words, this

    # $scope.callback.words = (error, data)->
    #   if not error
    #     $scope.selected_rep.words = data.json
    #     $scope.loaded.words = true
    #   else console.log "Error: ", error

#####################
# Define Watchers
#####################

    $scope.set_watchers_for_bioguide_id = _.once(()->
      $scope.$watch 'selected.rep1', ()->
        $scope.selected_rep = $scope.reps[$scope.selected.rep1.bioguide_id]
        $scope.get.bioguidedata()
    )

    $scope.set_watchers_for_transparencydata_id = _.once(()->
      $scope.$watch 'selected_rep.transparencydata_id', $scope.get.transparencydata()
    )

    # called from check_route_params in init section
    $scope.get.bioguidedata = ()->
      $scope.loaded.reset_all()
      $scope.get.transparencydata_id()
      $scope.get.committees()
      $scope.get.bills_sponsored()
      $scope.get.bills_cosponsored()

    # called from trandparencydata_id callback in API section
    $scope.get.transparencydata = ()->
      $scope.get.bio()
      $scope.get.contributors()
      $scope.get.industries()
      $scope.get.sectors()
      $scope.get.locale()
      $scope.get.type()

#####################
# Loading Checks
#####################

    $scope.loaded =
      reset_all: ()->
        $scope.loaded.bio = false
        $scope.loaded.committees = false
        $scope.loaded.bills_sponsored = false
        $scope.loaded.bills_cosponsored = false
        $scope.loaded.modals = false
        $scope.loaded.trandparencydata_id = false
        $scope.loaded.contributors = false
        $scope.loaded.industries = false
        $scope.loaded.sectors = false
        $scope.loaded.locale = false
        $scope.loaded.type = false
        $scope.loaded.words = false

    $scope.loaded.reset_all()  # sets the vales for the first time

    $scope.loaded.modals_check = ()->
      if $scope.loaded.committees and $scope.loaded.bills_sponsored and $scope.loaded.bills_cosponsored
        $scope.loaded.modals = true

    $scope.$watch 'loaded.committees', $scope.loaded.modals_check
    $scope.$watch 'loaded.bills_sponsored', $scope.loaded.modals_check
    $scope.$watch 'loaded.bills_cosponsored', $scope.loaded.modals_check

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

#####################
# Set Reps by Route Params and Init
#####################

    # used when the id passed is a transparencydata_id and not a bioguide_id
    route_params_id_bio_callback = (error, data)->
      if not error
        console.log $scope.reps[data.metadata.bioguide_id]
        if $scope.reps[data.metadata.bioguide_id] is not undefined
          $scope.selected.rep1 = {name: $scope.reps[data.metadata.bioguide_id].overview.fullname, bioguide_id: data.metadata.bioguide_id}
          $scope.set_watchers_for_bioguide_id()
        else
          alert 'Only current representatives can be selected at this time. The Speaker of the House has been chosen as the default, sorry for the inconvenience.'
          $scope.selected.rep1 = {name: "Rep. John Boehner", bioguide_id: "B000589"}
          $scope.set_watchers_for_bioguide_id()
      else console.log "Error: ", error

    check_route_params = _.once(()->
      # check route params for rep ids
      if $routeParams.bioguide_id
        $scope.selected.rep1 = {name: $scope.reps[$routeParams.bioguide_id].overview.fullname, bioguide_id: $routeParams.bioguide_id}
        $scope.set_watchers_for_bioguide_id()
      else if $routeParams.id
        Api_get.influence "entities/#{$routeParams.id}.json?", route_params_id_bio_callback, this
      else # set default rep
        $scope.selected.rep1 = $scope.selected.rep1 or {name: "Rep. John Boehner", bioguide_id: "B000589"}
        $scope.set_watchers_for_bioguide_id()
    )

    $scope.check_if_rep_data_loaded = ()->
      if _.isEmpty($scope.reps)
        $timeout($scope.check_if_rep_data_loaded, 500)
      else
        check_route_params()

    # init
    $scope.check_if_rep_data_loaded()

  ])
