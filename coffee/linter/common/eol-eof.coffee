
LintWarning = require '../../warning/lint-warning'


module.exports = (inf) ->

  lines = inf.source.split '\n'

  warn = (code, desc, line, col) ->
    title = 'Lint Warning' + if code then ' (' + code + ')' else ''
    inf.res.warnings.push new LintWarning inf, {}, [line, col], desc, title

  if inf.maxLineLength is true
    max_line_len = 80
  else if inf.maxLineLength > 0 and
  parseInt(inf.maxLineLength, 10) is Number inf.maxLineLength
    max_line_len = Number inf.maxLineLength

  for line, i in lines

    # rule: unix-line-end-style
    if (not cr_found) and line.substr(line.length - 1) is '\r'
      cr_found = true
      warn 'EOL', 'CR (\'\\r\') character found at end of line', i,
           line.length - 1

    # rule: no-whitespace-line
    if (not trimmed = line.trim()) and line
      warn 'WSLN', 'Line contains white spaces only', i, 0

    # rule: no-whitespace-line-end
    else if (idx = line.indexOf(trimmed) + trimmed.length) < line.length
      warn 'EOLWS', 'Line has trailing white space', i, idx

    # rule: line-max-length
    else if max_line_len and line.length > max_line_len
      warn 'MAXLN', 'Line length exceeds ' + max_line_len, i, max_line_len

  # trailing-enter-character
  unless inf.source.substr(last = inf.source.length - 1) is '\n'

    title = 'Lint Warning (EOF)'
    desc = 'Missing enter character at end of file'
    pos = [lines.length - 1, lines[lines.length - 1].length]

    inf.res.warnings.push new LintWarning inf, {}, pos, desc, title

  else
    last_count = 1
    while inf.source.substr(last - last_count, 1) is '\n'
      last_count += 1
    if last_count > 1
      title = 'Lint Warning (EOFX)'
      desc = 'Unnecessary empty lines at end of file'
      pos = [lines.length - last_count, 0]

      inf.res.warnings.push new LintWarning inf, {}, pos, desc, title
