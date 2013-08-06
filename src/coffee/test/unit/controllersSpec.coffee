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
    @service;
    @ctrl;
    $httpBackend;

    beforeEach(inject( (_$httpBackend_, $rootScope, $controller, Api_get)->
      $httpBackend = $injector.get('$httpBackend')
      $httpBackend.whenGET(/.*/).respond({name: 'woohoo'})
      @scope = $rootScope.$new();
      @service = Api_get;
      @ctrl = $controller('IndividualCtrl', {
        $scope: @scope,
        Api_get: @service
      });
    ));

    afterEach( ()->
     $httpBackend.verifyNoOutstandingExpectation();
     $httpBackend.verifyNoOutstandingRequest();
    );

    it('should access the default zip value', ()->
      expect(@scope.zip).toEqual(94102);
    );

    it('should pull individual data based on the zip', ()->
      flag = false

      runs ()=>
        console.log 'running'
        @scope.get_rep_data_by_zip

      waitsFor ()->
        flag
      , "error", 1000
    );
  );
);