# Controllers

angular
  .module('influences.controllers', ['ui.bootstrap', 'influences.services'])
  .controller('NavCtrl', ['$scope', '$location', ($scope, $location)->
    $scope.navClass = (page)->
      if page is $location.path().substring(1) then 'active' else ''
  ])
  .controller('AppCtrl', ['$scope', 'version', 'data', ($scope, version, data)->
    $scope.version = version
    $scope.source = data.source
    $scope.license = data.license
  ])