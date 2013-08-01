# Services

angular
  .module('influences.services', [])
  .value('version', production: '0.1')
  .value('data',
    source:
      url: "http://sunlightfoundation.com/"
      name: "Sunlight Foundation"
    license:
      url: "http://sunlightlabs.github.io/datacommons/"
      name: "Various"
  )
  .factory 'Api_get', ['$http', ($http)->
    congress: (path, callback)->
      $http
        url: "http://congress.api.sunlightfoundation.com/#{path}&apikey=83c0368c509f468e992218f41e6529d7"
        method: "GET"
      .success (data, status, headers, config)->
        callback data.results
      .error (data, status, headers, config)->
        console.log("Error pulling #{path} from Sunlight Congress v3 API!")
    influence: (path, callback)->
      apiurl = "http://transparencydata.com/api/1.0/#{path}&apikey=83c0368c509f468e992218f41e6529d7"
      $http
        method: "GET"
        url: "http://query.yahooapis.com/v1/public/yql"
        params:
          q: "select * from json where url=\"#{apiurl}\""
          format: "json"
      .success (data, status, headers, config)->
        callback data.query.results.json
      .error (data, status, headers, config)->
        console.log("Error pulling votes from NYT API!")
  ]
