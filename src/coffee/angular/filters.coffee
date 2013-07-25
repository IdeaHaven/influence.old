# Filters

angular
  .module('influences.filters', [])
  .filter('interpolate', ['version', (version)->
    (text)->
      String(text).replace(/\%VERSION\%/mg, version)
  ])
