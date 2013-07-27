'use strict';

/* jasmine specs for controllers go here */


describe("Testing influences Module:", function() {

  it("should should be registered", function() {
    expect(angular.module("influences")).not.toBeNull;
  });

  it("should should have sub module influences.filters registered", function() {
    expect(angular.module("influences.filters")).not.toBeNull;
  });

  it("should should have sub module influences.services registered", function() {
    expect(angular.module("influences.services")).not.toBeNull;
  });

  it("should should have sub module influences.directives registered", function() {
    expect(angular.module("influences.directives")).not.toBeNull;
  });

  it("should should have sub module influences.controllers registered", function() {
    expect(angular.module("influences.controllers")).not.toBeNull;
  });


  describe("Dependencies:", function() {

    var module, dependencies;
    beforeEach(function() {
      module = angular.module("influences");
      dependencies = module.requires
    });

    it("should have influences.controllers as a dependency", function() {
      expect(dependencies[0]).toEqual('influences.filters');
    });

    it("should have influences.directives as a dependency", function() {
      expect(dependencies[1]).toEqual('influences.services');
    });

    it("should have influences.filters as a dependency", function() {
      expect(dependencies[2]).toEqual('influences.directives');
    });

    it("should have influences.services as a dependency", function() {
      expect(dependencies[3]).toEqual('influences.controllers');
    });
  });
});