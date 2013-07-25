# Controllers

angular
  .module('influences.controllers', [])
  .controller('IndividualCtrl', ['$scope', '$http', ($scope, $http)->
    # Pull down data about the individual
    $http
      url: "http://congress.api.sunlightfoundation.com/legislators/locate?zip=94404&apikey=83c0368c509f468e992218f41e6529d7"
      method: "GET"
    .success (data, status, headers, config)->
      $scope.data = data
    .error (data, status, headers, config)->
      $scope.status = status

    $scope.ind =
      name: "hahah"
  ])
  .controller('BillCtrl', ['$scope', ($scope)->
    $scope.name = "hahah"
  ])
