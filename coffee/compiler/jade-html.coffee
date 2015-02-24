
CompilationError   = require '../error/compilation-error'
CompilationWarning = require '../warning/compilation-warning'
compiler           = require 'jade'
util               = require 'util'


# patch jade to provide includes
compiler.Parser::_parseInclude = compiler.Parser::parseInclude
compiler.Parser::parseInclude = ->
  if (list = @options?.includes) and typeof list is 'object'
    tok  = @peek()
    path = @resolvePath tok.val.trim(), 'include'

    p = require 'path'
    file = p.resolve @filename
    path = p.resolve path

    if list instanceof Array
      for item in list
        if item is path
          return @_parseInclude()
      list.push path
    else
      list[file] ?= {}
      list[file][path] ?= []
      list[file][path].push tok.line

  @_parseInclude()



module.exports = (inf, cb) ->

  try
    orig_warn = console.warn
    console.warn = (msgs...) ->
      msg = []
      for item in msgs
        msg.push if typeof item is 'string' then item else util.inspect item
      msg = msg.join()

      if msg.substr(0, 9) is 'Warning: ' and
      ((pos = msg.indexOf ' for line ') > -1 or
       (pos = msg.indexOf ' on line ') > -1)
        desc = msg.substr 9, pos
        if isNaN line = Number msg.substr(pos + 1).split(' ')[2]
          line = null
        else
          line -= 1

        inf.res.warnings.push new CompilationWarning inf, msg, line, desc
      else
        inf.res.warnings.push new CompilationWarning inf, msg


    inf.res.compiled = compiler.render inf.source,
      filename:     inf.file
      compileDebug: false
      pretty:       true
      includes:     (includes = [])

    console.warn = orig_warn

    if Array.isArray includes
      inf.res.includes.push includes...

  catch err
    console.warn = orig_warn

    desc = String(err).split('\n\n')[1 ...].join '\n\n'

    for err_line in String(err).split '\n'
      if err_line.substr(0, 4) is '  > ' and
      (line_n = String(err_line.substr(4).split('|')[0]).trim()) and
      not isNaN line_n = Number line_n
        line = line_n - 1
        break

    inf.res.errors.push new CompilationError inf, err, line, desc

  cb()
