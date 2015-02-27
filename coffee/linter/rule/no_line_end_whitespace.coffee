
module.exports = (inf, source_type, msg_factory, title, lines) ->

  for line, i in lines

    if (not trimmed = line.trim()) and line
      desc = 'Line contains white spaces only'
      msg_factory [i, 0], desc, title

    else if (idx = line.indexOf(trimmed) + trimmed.length) < line.length
      desc = 'Line has trailing white space'
      msg_factory [i, idx], desc, title

  return
