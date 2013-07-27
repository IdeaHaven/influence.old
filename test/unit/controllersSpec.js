'use strict';

/* jasmine specs for controllers go here */

describe('influences controllers', function() {
  beforeEach(module('influences.controllers', ['ui.bootstrap', 'influences.services']));

  describe('IndividualCtrl', function(){

    var scope, ctrl, service, $httpBackend;

    beforeEach(inject(function(_$httpBackend_, $rootScope, $controller, Api_sunlight_get) {
      console.log('*** IN INJECT!!***: ', Api_sunlight_get);
      $httpBackend = _$httpBackend_;
      // ignore for now... this is an example of how I might implement this later
      // $httpBackend.expectGET('data/products.json').
      //     respond([{name: 'Celeri'}, {name: 'Panais'}]);

      scope = $rootScope.$new();
      service = Api_sunlight_get;
      ctrl = $controller('IndividualCtrl', {$scope: scope, Api_sunlight_get: service
      });
    }));

    xit('should create "products" model with 2 products fetched from xhr', function() {
      console.log('*** IN TEST!!***: ', scope);
      scope = {zip: 12345};
      expect(scope.zip).toEqual(12345);
    });
  });
});