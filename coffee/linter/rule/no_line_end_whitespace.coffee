
module.exports.source = (msg_factory, source) ->

  for line, i in source.split '\n'

    if (not trimmed = line.trim()) and line
      desc = 'Line contains white spaces only'
      msg_factory desc, i, 0

    else if (idx = line.indexOf(trimmed) + trimmed.length) < line.length
      desc = 'Line has trailing white space'
      msg_factory desc, i, idx

  return
