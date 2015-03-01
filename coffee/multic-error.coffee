
fs   = require 'fs'
path = require 'path'


intify = (n) ->
  unless String(n) is String(n).replace /[^0-9]/, ''
    return
  n = Number n


class MulticError extends Error

  column:      null
  file:        null
  line:        null
  sourceLines: null
  title:       null


  constructor: (inf, err, pos, description, title) ->

    if Array.isArray pos
      [line, column] = pos
    else
      line = pos

    if err and typeof err is 'object'
      orig_name = err?.constructor?.name
      if String(orig_name).toLowerCase() is 'error'
        orig_name = null

    @title = title or orig_name or @constructor.name
    @file  = inf.options.file

    if inf.options.file and (errfile = err?.file or err?.path) and
    (errfile = path.resolve errfile) isnt inf.options.file
      @file = errfile
      try
        override_source = fs.readFileSync errfile, {encoding: 'utf8'}
      catch
        line = column = null

    if (line_n = intify line)?
      @line = line_n

      if (column_n = intify column)?
        @column = column_n

      source = override_source or inf.source

      from = Math.max 0, line_n - 5
      if (sourcelines = source?.split('\n')[from .. line_n + 5])?.length
        for line_literal, i in sourcelines
          (@sourceLines ?= {})[from + i] = line_literal

    @message = description or err?.message or (if err then String(err) else '')
    super @message


  @parsePos: (line, column, line_off=0, column_off=0) ->
    if (line_n = intify line)?
      line_n += line_off
      if (column_n = intify column)?
        column_n += column_off
      return [line_n, column_n]
    null


  @posByIndex: (lines, col) ->
    line = 0
    while lines[line]? and col > len = lines[line].length
      col -= len + 1
      line += 1
    [line, col]


module.exports = MulticError
