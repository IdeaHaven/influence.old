# Controllers

angular
  .module('influences.controllers', ['ui.bootstrap', 'influences.services'])
  .controller('IndividualCtrl', ['$scope', 'Api_sunlight_get', ($scope, Api_sunlight_get)->
    # set default variables
    $scope.zip = 94102  # set default zip if one is not chosen

    # Define Methods
    get_rep_data_by_zip = ()->
      Api_sunlight_get "legislators/locate?zip=#{$scope.zip}", callback_rep_data_by_zip

    callback_rep_data_by_zip = (data)->
      $scope.reps = data
      $scope.selected_rep = $scope.reps[0]  # sets default selection for reps buttons
      for rep in $scope.reps
        rep.fullname = "" + rep.title + " " + rep.first_name + " " + rep.last_name

    extract_overview_info_from_selected_rep_data = (overview_keys)->
      if $scope.selected_rep.chamber is 'house'
        overview_keys = ['birthday', 'chamber', 'contact_form', 'district', 'facebook_id', 'fax', 'leadership_role', 'office', 'party', 'phone', 'state', 'state_name', 'term_end', 'term_start', 'twitter_id', 'website', 'youtube_id']
      else
        overview_keys = ['birthday', 'chamber', 'contact_form', 'facebook_id', 'fax', 'office', 'party', 'phone', 'senate_class', 'state', 'state_name', 'state_rank', 'term_end', 'term_start', 'twitter_id', 'website', 'youtube_id']
      $scope.selected_rep.overview = {}
      for item in overview_keys
        $scope.selected_rep.overview[item] = $scope.selected_rep[item]

    get_committees_data_by_selected_rep_id = ()->
      Api_sunlight_get "committees?member_ids=#{$scope.selected_rep.bioguide_id}", callback_committees_data_by_selected_rep_id

    callback_committees_data_by_selected_rep_id = (data)->
      console.log data
      $scope.selected_rep.committees = data

    # watchers
    $scope.$watch 'zip', get_rep_data_by_zip
    $scope.$watch 'selected_rep', extract_overview_info_from_selected_rep_data
    $scope.$watch 'selected_rep', get_committees_data_by_selected_rep_id

    # initial run
    get_rep_data_by_zip()

  ])
  .controller('BillCtrl', ['$scope', ($scope)->
    $scope.name = "hahah"
  ])
