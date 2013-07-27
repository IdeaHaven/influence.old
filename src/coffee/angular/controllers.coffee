# Controllers

angular
  .module('influences.controllers', ['ui.bootstrap', 'influences.services'])
  .controller('IndividualCtrl', ['$scope', 'Api_sunlight_get', ($scope, Api_sunlight_get)->
    # set default variables
    $scope.zip = $scope.zip or 94102  # set default zip if one is not chosen

    # Define Methods
    $scope.get_rep_data_by_zip = ()->
      Api_sunlight_get "legislators/locate?zip=#{$scope.zip}", $scope.update_rep_data_by_zip

    $scope.update_rep_data_by_zip = (data)->
      $scope.reps = data
      $scope.selected_rep = $scope.reps[0]  # sets default selection for reps buttons
      for rep in $scope.reps
        rep.fullname = "" + rep.title + " " + rep.first_name + " " + rep.last_name

    # watchers
    $scope.$watch('zip', $scope.get_rep_data_by_zip)

    # initial run
    $scope.get_rep_data_by_zip()

  ])
  .controller('BillCtrl', ['$scope', ($scope)->
    $scope.name = "hahah"
  ])
