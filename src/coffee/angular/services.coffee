# Services

# Demonstrate how to register services
# In this case it is a simple value service.
angular
  .module('influences.services', [])
  .factory 'Api_sunlight_get', ['$http', ($http)->
    return (path, callback)->
      $http
        url: "http://congress.api.sunlightfoundation.com/#{path}&apikey=83c0368c509f468e992218f41e6529d7"
        method: "GET"
      .success (data, status, headers, config)->
        return data.results
      .error (data, status, headers, config)->
        return status
  ]
