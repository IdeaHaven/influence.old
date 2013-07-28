# Services

angular
  .module('influences.services', [])
  .value('version', '0.1')
  .factory 'Api_sunlight_get', ['$http', ($http)->
    return (path, callback)->
      $http
        url: "http://congress.api.sunlightfoundation.com/#{path}&apikey=83c0368c509f468e992218f41e6529d7"
        method: "GET"
      .success (data, status, headers, config)->
        callback data.results
      .error (data, status, headers, config)->
        console.log("Error pulling #{path} from Sunlight API!")
  ]
