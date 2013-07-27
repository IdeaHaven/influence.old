'use strict';

/* jasmine specs for services go here */

describe('service', function() {
  beforeEach(module('influences.services'));


  describe('Sunlight API', function() {

    xit('should return reps based on a zip', inject(function(Api_sunlight_get) {
      console.log(Api_sunlight_get);
      Api_sunlight_get('legislators/locate?zip=10458', function(data){
        expect(data.length).toEqual(5);
      });
    }));
  });
});
