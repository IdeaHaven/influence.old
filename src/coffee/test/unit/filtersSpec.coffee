'use strict';

# jasmine specs for filters go here

describe('filter', ()->
  beforeEach(module('influences.filters'));


  describe('interpolate', ()->
    beforeEach(module( ($provide)->
      $provide.value('version', 'TEST_VER');
    ));


    xit('should replace VERSION', inject( (interpolateFilter)->
      expect(interpolateFilter('before %VERSION% after')).toEqual('before TEST_VER after');
    ));
  );
);
