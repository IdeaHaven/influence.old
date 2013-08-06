# Controllers

angular
  .module('influences.controllers')
  .controller('IndividualCtrl', ['$scope', 'Api_get', ($scope, Api_get)->

    # set default variables
    $scope.zip = 94102  # set default zip if one is not chosen
    $scope.sub_view_rep_type = 'loading' # set loading view until rep data is loaded

    # Define Methods
    $scope.get_rep_data_by_zip = ()->
      Api_get.congress "legislators/locate?zip=#{$scope.zip}", $scope.callback_rep_data_by_location

    $scope.callback_rep_data_by_location = (err, data)->
      $scope.sub_view_rep_type = 'loading' # set loading view until rep data is loaded
      $scope.reps = {}
      for rep in data
        rep.fullname = "#{rep.title}. #{rep.first_name} #{rep.last_name}"
        rep.chamber = rep.chamber.charAt(0).toUpperCase() + rep.chamber.slice(1)  # cap first letter
        rep.party_name = if rep.party is "D" then "Democrat" else if rep.party is "R" then "Republican" else rep.party
        $scope.reps[rep.bioguide_id] = {}
        $scope.reps[rep.bioguide_id].overview = rep
      $scope.selected_rep = $scope.reps[data[0].bioguide_id]  # sets default selection for reps buttons

      run_once = run_once or false
      if not run_once
        $scope.set_watchers_for_bioguide_id_dependent_data() # only set the watchers once
        run_once = true

    $scope.get_committees_data_by_selected_rep_id = ()->
      if not $scope.selected_rep.overview.leadership_role
        if not $scope.selected_rep.committees
          Api_get.congress "committees?member_ids=#{$scope.selected_rep.overview.bioguide_id}", $scope.callback_committees_data_by_selected_rep_id

    $scope.callback_committees_data_by_selected_rep_id = (err, data)->
      $scope.selected_rep.committees = data

    $scope.get_sponsored_bills_data_by_selected_rep_id = ()->
      if not $scope.selected_rep.bills
        Api_get.congress "bills?sponsor_id=#{$scope.selected_rep.overview.bioguide_id}", $scope.callback_sponsored_bills_data_by_selected_rep_id

    $scope.callback_sponsored_bills_data_by_selected_rep_id = (err, data)->
      $scope.selected_rep.bills = $scope.selected_rep.bills or []
      for bill in data
        if not bill.short_title
          bill.short_title = bill.official_title
      $scope.selected_rep.bills.sponsored = data

    $scope.get_cosponsored_bills_data_by_selected_rep_id = ()->
      if not $scope.selected_rep.bills
        Api_get.congress "bills?cosponsor_ids=#{$scope.selected_rep.overview.bioguide_id}", $scope.callback_cosponsored_bills_data_by_selected_rep_id

    $scope.callback_cosponsored_bills_data_by_selected_rep_id = (err, data)->
      $scope.selected_rep.bills = $scope.selected_rep.bills or []
      for bill in data
        if not bill.short_title
          bill.short_title = bill.official_title
      $scope.selected_rep.bills.cosponsored = data

    $scope.get_wdsponsor_bills_data_by_selected_rep_id = ()->
      if not $scope.selected_rep.bills
        Api_get.congress "bills?withdrawn_cosponsor_ids=#{$scope.selected_rep.overview.bioguide_id}", $scope.callback_wdsponsor_bills_data_by_selected_rep_id

    $scope.callback_wdsponsor_bills_data_by_selected_rep_id = (err, data)->
      if data[0]
        $scope.selected_rep.bills = $scope.selected_rep.bills or []
        for bill in data
          if not bill.short_title
            bill.short_title = bill.official_title
        $scope.selected_rep.bills.wdsponsor = data

    $scope.get_transparencydata_id_by_selected_rep_bioguide_id = ()->
      Api_get.influence "entities/id_lookup.json?bioguide_id=#{$scope.selected_rep.overview.bioguide_id}", $scope.callback_transparencydata_id_by_rep_bioguide_id

    $scope.callback_transparencydata_id_by_rep_bioguide_id = (err, data)->
      $scope.selected_rep.transparencydata_id = data.id

      run_once = run_once or false
      if not run_once
        $scope.set_watchers_for_transparencydata_id_dependent_data() # only set the watchers once
        run_once = true

    $scope.get_contributors_by_selected_rep_transparencydata_id = ()->
      Api_get.influence "aggregates/pol/#{$scope.selected_rep.transparencydata_id}/contributors.json?cycle=2012&limit=10", $scope.callback_contributors_by_selected_rep_transparencydata_id

    $scope.callback_contributors_by_selected_rep_transparencydata_id = (err, data)->
      $scope.selected_rep.funding = $scope.selected_rep.funding or {}
      $scope.selected_rep.funding.contributors = data.json

    $scope.get_industries_by_selected_rep_transparencydata_id = ()->
      Api_get.influence "aggregates/pol/#{$scope.selected_rep.transparencydata_id}/contributors/industries.json?cycle=2012&limit=10", $scope.callback_industries_by_selected_rep_transparencydata_id

    $scope.callback_industries_by_selected_rep_transparencydata_id = (err, data)->
      $scope.selected_rep.funding = $scope.selected_rep.funding or {}
      $scope.selected_rep.funding.industries = data.json

    $scope.get_sectors_by_selected_rep_transparencydata_id = ()->
      Api_get.influence "aggregates/pol/#{$scope.selected_rep.transparencydata_id}/contributors/sectors.json?cycle=2012&limit=10", $scope.callback_sectors_by_selected_rep_transparencydata_id

    $scope.callback_sectors_by_selected_rep_transparencydata_id = (err, data)->
      $scope.selected_rep.funding = $scope.selected_rep.funding or {}
      $scope.selected_rep.funding.sectors = data.json

    $scope.get_local_breakdown_by_selected_rep_transparencydata_id = ()->
      Api_get.influence "aggregates/pol/#{$scope.selected_rep.transparencydata_id}/contributors/local_breakdown.json?cycle=2012&limit=10", $scope.callback_local_breakdown_by_selected_rep_transparencydata_id

    $scope.callback_local_breakdown_by_selected_rep_transparencydata_id = (err, data)->
      $scope.selected_rep.funding = $scope.selected_rep.funding or {}
      $scope.selected_rep.funding.local_breakdown = data

    $scope.get_type_breakdown_by_selected_rep_transparencydata_id = ()->
      Api_get.influence "aggregates/pol/#{$scope.selected_rep.transparencydata_id}/contributors/type_breakdown.json?cycle=2012&limit=10", $scope.callback_type_breakdown_by_selected_rep_transparencydata_id

    $scope.callback_type_breakdown_by_selected_rep_transparencydata_id = (err, data)->
      $scope.selected_rep.funding = $scope.selected_rep.funding or {}
      $scope.selected_rep.funding.type_breakdown = data

    $scope.set_view_by_selected_rep_role = ()->
      if $scope.selected_rep.overview.chamber is 'House' and not $scope.selected_rep.overview.leadership_role
        $scope.sub_view_rep_type = 'house'
      else if $scope.selected_rep.overview.chamber is 'House' and $scope.selected_rep.overview.leadership_role
        $scope.sub_view_rep_type = 'house-leader'
      else if $scope.selected_rep.overview.chamber is 'Senate'
        $scope.sub_view_rep_type = 'senate'

    $scope.set_watchers_for_bioguide_id_dependent_data = ()->
      $scope.$watch 'selected_rep', $scope.set_view_by_selected_rep_role
      $scope.$watch 'selected_rep', $scope.get_committees_data_by_selected_rep_id
      # $scope.$watch 'selected_rep', $scope.get_votes_data_by_selected_rep_id
      $scope.$watch 'selected_rep', $scope.get_sponsored_bills_data_by_selected_rep_id
      $scope.$watch 'selected_rep', $scope.get_cosponsored_bills_data_by_selected_rep_id
      $scope.$watch 'selected_rep', $scope.get_wdsponsor_bills_data_by_selected_rep_id
      $scope.$watch 'selected_rep', $scope.get_transparencydata_id_by_selected_rep_bioguide_id

    $scope.set_watchers_for_transparencydata_id_dependent_data = ()->
      $scope.$watch 'selected_rep.transparencydata_id', $scope.get_contributors_by_selected_rep_transparencydata_id
      $scope.$watch 'selected_rep.transparencydata_id', $scope.get_industries_by_selected_rep_transparencydata_id
      $scope.$watch 'selected_rep.transparencydata_id', $scope.get_sectors_by_selected_rep_transparencydata_id
      $scope.$watch 'selected_rep.transparencydata_id', $scope.get_local_breakdown_by_selected_rep_transparencydata_id
      $scope.$watch 'selected_rep.transparencydata_id', $scope.get_type_breakdown_by_selected_rep_transparencydata_id

    $scope.$watch 'zip', $scope.get_rep_data_by_zip
  ])
