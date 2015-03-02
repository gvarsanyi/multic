
CompilationError   = require '../error/compilation-error'
CompilationWarning = require '../warning/compilation-warning'
Jade               = require 'jade'
util               = require 'util'


require '../patch/jade-patch'


console.log 'Jade.Parser::parseInclude', Jade.Parser::parseInclude

module.exports = (inf, cb) ->

  if inf.compiledJade?
    inf.res.compiled = inf.compiledJade
    return cb()

  try
    orig_warn = console.warn
    console.warn = (msgs...) ->
      msg = []
      for item in msgs
        msg.push if typeof item is 'string' then item else util.inspect item
      msg = msg.join()

      if msg.substr(0, 9) is 'Warning: ' and
      ((spos = msg.indexOf ' for line ') > -1 or
       (spos = msg.indexOf ' on line ') > -1)
        desc = msg.substr 9, spos

        if -1 < fpos = msg.lastIndexOf ' file "'
          file = msg.substr fpos + 7
          file = file.substr 0, file.length - 1

        line = msg.substr(spos + 1).split(' ')[2]
        pos = CompilationWarning.parsePos line, null, -1

        mock = {file, message: msg}

        inf.res.warnings.push new CompilationWarning inf, mock, pos, desc
      else
        inf.res.warnings.push new CompilationWarning inf, msg

    cfg =
      compileDebug: false
      pretty:       true
      includes:     (includes = [])

    if inf.options.file
      cfg.filename = inf.options.file

    if Array.isArray inf.jadeNodes
      cfg.nodes = inf.jadeNodes

    inf.res.compiled = Jade.render inf.source, cfg

    console.warn = orig_warn

    if Array.isArray includes
      inf.res.includes.push includes...

  catch err
    console.warn = orig_warn

    desc = String(err).split('\n\n')[1 ...].join '\n\n'

    for err_line in String(err).split '\n' when err_line.substr(0, 4) is '  > '
      line = String(err_line.substr(4).split('|')[0]).trim()
      break

    pos = CompilationError.parsePos line, null, -1

    inf.res.errors.push new CompilationError inf, err, pos, desc

  cb()
