'use strict';

# jasmine specs for services go here

describe('service', ()->
  beforeEach(module('influences.services'));


  describe('Sunlight API', ()->

    xit('should return reps based on a zip', inject( (Api_sunlight_get)->
      console.log(Api_sunlight_get);
      Api_sunlight_get('legislators/locate?zip=10458', (data)->
        expect(data.length).toEqual(5);
      );
    ));
  );
);
