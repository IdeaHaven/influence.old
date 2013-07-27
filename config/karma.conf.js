basePath = '../';

files = [
  JASMINE,
  JASMINE_ADAPTER,
  'app/lib/angular.js',
  'app/lib/bootstrap.js',  // this was written with angular modules and is a dep for some tests
  'test/lib/angular/angular-mocks.js',
  'app/js/*.js',
  'test/unit/**/*.js'
];

autoWatch = true;

browsers = ['Chrome'];

junitReporter = {
  outputFile: 'test_out/unit.xml',
  suite: 'unit'
};
