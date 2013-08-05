'use strict';

# jasmine specs for controllers go here


describe("Testing influences Module:", ()->

  it("should should be registered", ()->
    expect(angular.module("influences")).not.toBeNull;
  );

  it("should should have sub module influences.filters registered", ()->
    expect(angular.module("influences.filters")).not.toBeNull;
  );

  it("should should have sub module influences.services registered", ()->
    expect(angular.module("influences.services")).not.toBeNull;
  );

  it("should should have sub module influences.directives registered", ()->
    expect(angular.module("influences.directives")).not.toBeNull;
  );

  it("should should have sub module influences.controllers registered", ()->
    expect(angular.module("influences.controllers")).not.toBeNull;
  );


  describe("Dependencies:", ()->

    @module;
    @dependencies;

    beforeEach(()->
      @module = angular.module("influences");
      @dependencies = @module.requires
    );

    it("should have influences.controllers as a dependency", ()->
      expect(@dependencies[0]).toEqual('influences.filters');
    );

    it("should have influences.directives as a dependency", ()->
      expect(@dependencies[1]).toEqual('influences.services');
    );

    it("should have influences.filters as a dependency", ()->
      expect(@dependencies[2]).toEqual('influences.directives');
    );

    it("should have influences.services as a dependency", ()->
      expect(@dependencies[3]).toEqual('influences.controllers');
    );
  );
);