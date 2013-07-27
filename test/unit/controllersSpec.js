'use strict';

/* jasmine specs for controllers go here */

describe('controllers', function() {
  beforeEach(module('influences.controllers', ['ui.bootstrap', 'influences.services']));

  describe('IndividualCtrl', function() {
    var scope, ctrl, service;

    beforeEach(inject(function($rootScope, $controller, Api_sunlight_get) {
      scope = $rootScope.$new();
      ctrl = $controller('IndividualCtrl', {$scope: scope, Api_sunlight_get: Api_sunlight_get});
    }));

    it('should pull reps data from the API by zip', function() {
      inject(function($rootScope, $controller) {
        scope = $rootScope.$new();
        ctrl = $controller("IndividualCtrl", {
          $scope: scope
        });
      });
      console.log('2Scope: ', scope);
      scope.zip = 44313;
      scope.get_rep_data_by_zip();
      expect(scope.reps.length).toEqual(5);
    });

  });
});
