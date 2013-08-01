# Controllers

angular
  .module('influences.controllers', ['ui.bootstrap', 'influences.services'])
  .controller('NavCtrl', ['$scope', '$location', ($scope, $location)->
    $scope.navClass = (page)->
      if page is $location.path().substring(1) then 'active' else ''
  ])
