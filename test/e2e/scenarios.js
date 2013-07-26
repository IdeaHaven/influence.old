'use strict';

/* http://docs.angularjs.org/guide/dev_guide.e2e-testing */

describe('my app', function() {

  beforeEach(function() {
    browser().navigateTo('../../app/index.html');
  });


  it('should automatically redirect to /individual when location hash/fragment is empty', function() {
    expect(browser().location().url()).toBe("/individual");
  });


  describe('individual', function() {

    beforeEach(function() {
      browser().navigateTo('#/individual');
    });


    it('should render individual view when user navigates to /individual', function() {
      expect(element('[ng-view] span:first').text()).
        toMatch(/Zip/);
    });

  });


  describe('bill view', function() {

    beforeEach(function() {
      browser().navigateTo('#/bill');
    });


    it('should render bill view when user navigates to /bill', function() {
      expect(element('[ng-view] p:first').text()).
        toMatch(/partial for view 2/);
    });

  });
});
