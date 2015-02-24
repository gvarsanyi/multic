
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

    if inf.file
      @file = inf.file

    if String(line).indexOf('.') is -1 and
    (not isNaN line_n = parseInt line, 10) and line_n >= 0
      @line = line_n
      from = Math.max 0, line_n - 5
      if (sourcelines = inf.source?.split('\n')[from .. line_n + 5])?.length
        for line_literal, i in sourcelines
          (@sourceLines ?= {})[from + i] = line_literal

    if column? and String(column).indexOf('.') is -1 and
    (not isNaN column_n = parseInt column, 10) and column_n >= 0
      @column = column_n

    @message = description or err?.message or (if err then String(err) else '')
    super @message


module.exports = MulticError
