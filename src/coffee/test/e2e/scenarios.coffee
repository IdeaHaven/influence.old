'use strict';

# http://docs.angularjs.org/guide/dev_guide.e2e-testing

describe('my app', ()->

  beforeEach(()->
    browser().navigateTo('../../app/index.html')
  )

  it('should automatically redirect to /overview when location hash/fragment is empty', ()->
    expect(browser().location().url()).toBe("/overview")
  )

  describe('individual', ()->

    beforeEach(()->
      browser().navigateTo('#/individual')
    )

    it('should render individual view when user navigates to /individual', ()->
      expect(element('[ng-view] span:first').text()).toMatch(/Zip/)
    )

    it('should change the data when a new zip is entered', ()->
      expect(element('[ng-view] h1:first').text()).toMatch(/Nancy/);
      input('zip').enter('44313');
      expect(element('[ng-view] h1:first').text()).toMatch(/David/);
    )
  )

  describe('bill view', ()->

    beforeEach(()->
      browser().navigateTo('#/bill')
    )

    it('should render bill view when user navigates to /bill', ()->
      expect(element('[ng-view] p:first').text()).toMatch(/partial for view 2/)
    )
  )
)