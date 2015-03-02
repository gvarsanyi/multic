
Jade = require 'jade'
fs   = require 'fs'
path = require 'path'
util = require 'util'


# expose includes, include_sources
Jade.Parser::_multicPatch_parseInclude = Jade.Parser::parseInclude
Jade.Parser::parseInclude = ->

  if Array.isArray includes = @options?._multic_includes
    if token = @peek()
      include_path = @resolvePath token.val.trim(), 'include'

      unless include_path in includes
        includes.push include_path

  # fs.readFileSync proxy
  read_file_sync = fs.readFileSync
  if (include_sources = @options?._multic_includeSources) and
  typeof include_sources is 'object'
    fs.readFileSync = (file_path, opts) ->
      include_sources[path.resolve file_path] ?= read_file_sync file_path, opts

  try
    res = @_multicPatch_parseInclude()
  finally
    fs.readFileSync = read_file_sync

  res


# expose parsed nodes
Jade.Parser::_multicPatch_parseExpr = Jade.Parser::parseExpr
Jade.Parser::parseExpr = ->

  expr = @_multicPatch_parseExpr()

  if Array.isArray @options?.nodes
    @options?.nodes.push expr

  expr


# grab warnings
orig_jade_render = Jade.render
Jade.render = (str, options, fn) ->
  orig_warn = console.warn
  if Array.isArray warnings = options?._multic_warnings
    console.warn = (msgs...) ->
      msg = []
      for item in msgs
        msg.push if typeof item is 'string' then item else util.inspect item
      msg = msg.join()

      unless msg.substr(0, 9) is 'Warning: '
        return orig_warn msgs...

      mock = {}

      if (spos = msg.indexOf ' for line ') > -1 or
      (spos = msg.indexOf ' on line ') > -1
        desc = msg.substr 9, spos

        if (line = msg.substr(spos + 1).split(' ')[2])? and line > 0 and
        parseInt(line, 10) is line = Number line
          warning_line = line - 1

      if -1 < fpos = msg.lastIndexOf ' file "'
        file = msg.substr fpos + 7
        file = path.resolve file.substr 0, file.length - 1

      warnings.push err = new Error desc
      if warning_line
        err.line = warning_line
      if file
        err.file = file

      return
  try
    res = orig_jade_render str, options, fn
  finally
    console.warn = orig_warn

  res
