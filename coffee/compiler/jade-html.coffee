
CompilationError   = require '../error/compilation-error'
CompilationWarning = require '../warning/compilation-warning'
compiler           = require 'jade'
path               = require 'path'
util               = require 'util'


# patch jade to provide includes
compiler.Parser::_parseInclude = compiler.Parser::parseInclude
compiler.Parser::parseInclude = ->
  if (list = @options?.includes) and typeof list is 'object'
    tok   = @peek()
    fpath = @resolvePath tok.val.trim(), 'include'

    file  = path.resolve @filename
    fpath = path.resolve fpath

    if list instanceof Array
      for item in list
        if item is fpath
          return @_parseInclude()
      list.push fpath
    else
      list[file] ?= {}
      list[file][fpath] ?= []
      list[file][fpath].push tok.line

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
      ((spos = msg.indexOf ' for line ') > -1 or
       (spos = msg.indexOf ' on line ') > -1)
        desc = msg.substr 9, spos

        line = msg.substr(spos + 1).split(' ')[2]
        pos = CompilationError.parsePos line, null, -1

        inf.res.warnings.push new CompilationWarning inf, msg, pos, desc
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

    for err_line in String(err).split '\n' when err_line.substr(0, 4) is '  > '
      line = String(err_line.substr(4).split('|')[0]).trim()
      break

    pos = CompilationError.parsePos line, null, -1

    inf.res.errors.push new CompilationError inf, err, pos, desc

  cb()
