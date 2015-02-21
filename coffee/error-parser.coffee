
module.exports = (err, _line, description, title) ->

  if Array.isArray _line
    [_line, _column] = _line

  parsed_error =
    kscFileError: true
    title:        title or err?.constructor?.name or 'Error'

  if inf.file
    parsed_error.file = inf.file

  if description
    parsed_error.description = description

  if String(_line).indexOf('.') is -1 and
  (not isNaN line = parseInt _line, 10) and line >= 0
    parsed_error.line = line
    from = Math.max 0, line - 5
    if (source_lines = inf.source?.split('\n')[from .. line + 5])?.length
      for line_literal, i in source_lines
        (parsed_error.sourceLines ?= {})[from + i] = line_literal

  if String(_column).indexOf('.') is -1 and
  (not isNaN column = parseInt _column, 10) and column >= 0
    parsed_error.column = column

  parsed_error
