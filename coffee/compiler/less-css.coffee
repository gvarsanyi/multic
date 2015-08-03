
CompilationError = require '../error/compilation-error'
Less             = require 'less'
fs               = require 'fs'
path             = require 'path'


module.exports = (inf, cb) ->

  if inf.compiledLess?
    inf.res.compiled = inf.compiledLess
    return cb()

  opts =
    paths: []


  content_ready = (file_content) ->

    try

      Less.render inf.source or file_content, opts, (err, res) ->

        if err
          pos = CompilationError.parsePos err.line, err.column, -1, -1
          inf.res.errors.push new CompilationError inf, err, pos
          return cb()

        if (includes = res.imports)?.length
          inf.res.includes.push includes...

        inf.res.compiled = res.css

        unless inf.includeSources and typeof inf.includeSources is 'object' and
        includes?.length
          return cb()

        loaded = 0
        for include in includes
          do (include) ->
            fs.readFile include, {encoding: 'utf8'}, (err, data) ->
              if typeof data is 'string' and not err
                inf.includeSources[include] = data
              loaded += 1
              if loaded >= includes.length
                return cb()
        return

    catch err

      inf.res.errors.push new CompilationError inf, err
      cb()


  if inf.options.file

    opts.filename = inf.options.file
    opts.paths.push path.resolve path.dirname(inf.options.file) + '/'


  if inf.options.file and not inf.source

    fs.readFile inf.options.file, {encoding: 'utf8'}, (err, data) ->

      if err
        inf.res.errors.push new CompilationError inf, err
        cb()

      content_ready data

  else

    content_ready()
