# Services

angular
  .module('influences.services', [])
  .value('version', production: '0.6.0')
  .value('attribution',
    source:
      url: "http://sunlightfoundation.com/"
      name: "Sunlight Foundation"
    license:
      url: "http://sunlightlabs.github.io/datacommons/"
      name: "Various"
  )
  .factory 'Api_get', ['$http', ($http)->
    congress: (path, callback, context)->
      args = Array.prototype.slice.call(arguments, 2)
      context = args.shift()
      $http
        url: "http://congress.api.sunlightfoundation.com/#{path}&apikey=83c0368c509f468e992218f41e6529d7"
        method: "GET"
      .success (data, status, headers, config)->
        args.unshift data.results
        args.unshift null
        callback.apply(context, args)
      .error (data, status, headers, config)->
        callback "Error pulling #{path} from Sunlight Congress v3 API", null
    influence: (path, callback, context)->
      args = Array.prototype.slice.call(arguments, 2)
      context = args.shift()
      apiurl = "http://transparencydata.com/api/1.0/#{path}apikey=83c0368c509f468e992218f41e6529d7"
      $http
        method: "GET"
        url: "http://query.yahooapis.com/v1/public/yql"
        params:
          q: "select * from json where url=\"#{apiurl}\""
          format: "json"
      .success (data, status, headers, config)->
        if data.query.results
          args.unshift data.query.results.json
          args.unshift null
          callback.apply(context, args)
      .error (data, status, headers, config)->
        callback "Error pulling #{path} from Sunlight Influence Explorer API", null
    words: (path, callback, context)->
      args = Array.prototype.slice.call(arguments, 2)
      context = args.shift()
      apiurl = "http://capitolwords.org/api/1/#{path}&apikey=83c0368c509f468e992218f41e6529d7"
      $http
        method: "GET"
        url: "http://query.yahooapis.com/v1/public/yql"
        params:
          q: "select * from json where url=\"#{apiurl}\""
          format: "json"
      .success (data, status, headers, config)->
        args.unshift data.query.results.json
        args.unshift null
        callback.apply(context, args)
      .error (data, status, headers, config)->
        callback "Error pulling #{path} from Sunlight Influence Explorer API", null
  ]
