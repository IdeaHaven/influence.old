# Controllers

angular
  .module('influences.controllers', ['ui.bootstrap', 'influences.services'])
  .controller('IndividualCtrl', ['$scope', 'Api_sunlight_get', ($scope, Api_sunlight_get)->
    # set default variables
    $scope.zip = 94102  # set default zip if one is not chosen
    $scope.sub_view = 'individual-house' # set loading view until rep data is loaded

    # Define Methods
    get_rep_data_by_zip = ()->
      Api_sunlight_get "legislators/locate?zip=#{$scope.zip}", callback_rep_data_by_zip

    callback_rep_data_by_zip = (data)->
      $scope.reps = data
      for rep in $scope.reps
        rep.fullname = "#{rep.title}. #{rep.first_name} #{rep.last_name}"
        rep.chamber = rep.chamber.charAt(0).toUpperCase() + rep.chamber.slice(1)  # cap first letter
        rep.party_name = if rep.party is "D" then "Democrat" else if rep.party is "R" then "Republican" else rep.party
      $scope.selected_rep = $scope.reps[0]  # sets default selection for reps buttons
      set_watchers_for_dependent_data()

    # only do this if leadership roll is null
    get_committees_data_by_selected_rep_id = ()->
      if not $scope.selected_rep.leadership_role
        Api_sunlight_get "committees?member_ids=#{$scope.selected_rep.bioguide_id}", callback_committees_data_by_selected_rep_id

    callback_committees_data_by_selected_rep_id = (data)->
      $scope.selected_rep.committees = data

    get_sponsored_bills_data_by_selected_rep_id = ()->
      Api_sunlight_get "bills?sponsor_id=#{$scope.selected_rep.bioguide_id}", callback_sponsored_bills_data_by_selected_rep_id

    callback_sponsored_bills_data_by_selected_rep_id = (data)->
      console.log data
      $scope.selected_rep.bills = $scope.selected_rep.bills or {}
      $scope.selected_rep.bills.sponsored = data

    set_view_by_selected_rep_role = ()->
      if $scope.selected_rep.chamber is 'House' and not $scope.selected_rep.leadership_role
        $scope.sub_view = 'house'
      if $scope.selected_rep.chamber is 'House' and $scope.selected_rep.leadership_role
        $scope.sub_view = 'house-leader'
      if $scope.selected_rep.chamber is 'Senate'
        $scope.sub_view = 'senate'

    set_watchers_for_dependent_data = ()->
      $scope.$watch 'selected_rep', set_view_by_selected_rep_role
      $scope.$watch 'selected_rep', get_committees_data_by_selected_rep_id
      $scope.$watch 'selected_rep', get_sponsored_bills_data_by_selected_rep_id

    # independent watchers
    $scope.$watch 'zip', get_rep_data_by_zip


  ])
  .controller('BillCtrl', ['$scope', ($scope)->
    $scope.name = "hahah"
  ])
