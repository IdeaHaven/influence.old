# Controllers

angular
  .module('influences.controllers')
  .controller('OverviewCtrl', ['$scope', 'Api_get', ($scope, Api_get)->
    $scope.test = "woohoo"
  ])
