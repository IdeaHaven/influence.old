'use strict';

# jasmine specs for directives go here

describe('directives', ()->
  beforeEach(module('influences.directives'));

  describe('app-version', ()->
    xit('should print current version', ()->
      module( ($provide)->
        $provide.value('version', 'TEST_VER');
      );
      inject( ($compile, $rootScope)->
        element = $compile('<span app-version></span>')($rootScope);
        expect(element.text()).toEqual('TEST_VER');
      );
    );
  );
);
