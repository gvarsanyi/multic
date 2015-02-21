
sources =
  coffee: ['js']
  css:    ['min']
  es6:    ['js']
  html:   ['js', 'min']
  jade:   ['html', 'js']
  js:     ['min']
  sass:   ['css']

for source, targets of sources
  do (source, targets) ->
    module.exports[source] = (compilable) ->
      unless typeof compilable is 'string'
        compilable = ''

      res = {}

      for target in targets
        do (target) ->
          compile = (opts, cb) ->
            if typeof opts is 'function' and not cb?
              [cb, opts] = [opts, {}]

            unless opts and typeof opts is 'object'
              throw new Error 'Argument `options` must be object type'
            unless typeof cb is 'function'
              throw new Error 'Argument `callback` is a required function'

            opts.source = compilable
            if target is 'min'
              require('./minifier/' + target) opts, cb
            else
              require('./compiler/' + source + '-' + target) opts, cb

          unless target is 'min'
            compile.min = (opts, cb) ->
              if typeof opts is 'function' and not cb?
                [cb, opts] = [opts, {}]

              unless typeof cb is 'function'
                throw new Error 'Argument `callback` is a required function'

              compile opts, (err, compiled, includes, warnings1) ->
                if err
                  return cb err

                opts.source = compiled
                minifier = require './minifier/' + target
                minifier opts, (err, minified, warnings2) ->
                  if err
                    return cb err

                  if warnings1?.length or warnings2?.length
                    warnings = (warnings1 or []).concat warnings2 or []

                  cb null, compiled, minified, includes, warnings

          res[target] = compile
      res

return
