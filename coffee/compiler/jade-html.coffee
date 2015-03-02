
CompilationError   = require '../error/compilation-error'
CompilationWarning = require '../warning/compilation-warning'
Jade               = require 'jade'


require '../patch/jade-patch'


module.exports = (inf, cb) ->

  if inf.compiledJade?
    inf.res.compiled = inf.compiledJade
    return cb()

  try
    cfg =
      compileDebug:     false
      pretty:           true
      _multic_includes: (includes = [])
      _multic_warnings: (warnings = [])

    if inf.options.file
      cfg.filename = inf.options.file

    if Array.isArray inf.sourceMap
      cfg.nodes = inf.sourceMap

    if inf.includeSources and typeof inf.includeSources is 'object'
      cfg._multic_includeSources = inf.includeSources

    inf.res.compiled = Jade.render inf.source, cfg

  catch err
    desc = String(err).split('\n\n')[1 ...].join '\n\n'

    for err_line in String(err).split '\n' when err_line.substr(0, 4) is '  > '
      line = String(err_line.substr(4).split('|')[0]).trim()
      break

    pos = CompilationError.parsePos line, null, -1

    inf.res.errors.push new CompilationError inf, err, pos, desc

  finally

    for warning in warnings
      inf.res.warnings.push new CompilationWarning inf, warning, warning.line

    inf.res.includes.push includes...

  cb()
