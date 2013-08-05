'use strict';

# jasmine specs for controllers go here

describe('influences controllers', ()->
  beforeEach(module('influences.controllers'));
  beforeEach(()->
    module('ui.bootstrap');
    module('influences.services');
  );

  describe('IndividualCtrl', ()->

    @scope;
    @ctrl;
    @service;
    @$httpBackend;

    beforeEach(inject( (_$httpBackend_, $rootScope, $controller, Api_get)->
      @$httpBackend = _$httpBackend_;
      # ignore for now... this is an example of how I might implement this later
      # $httpBackend.expectGET('data/products.json').
      #     respond([{name: 'Celeri'}, {name: 'Panais'}]);

      @scope = $rootScope.$new();
      @service = Api_get;
      @ctrl = $controller('IndividualCtrl', {
        $scope: @scope,
        Api_get: @service
      });
    ));

    it('should set the correct zip value', ()->
      expect(@scope.zip).toEqual(94102);
    );
  );
);