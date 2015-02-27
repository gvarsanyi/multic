
module.exports = (inf, source_type, msg_factory, title, lines) ->

  maxlen = inf.options.max_line_length
  if maxlen is true
    maxlen = 80
  else
    maxlen = parseInt maxlen, 10

  unless maxlen > 0
    return

  for line, i in lines when line.length > maxlen

    desc = 'Line length exceeds allowed maximum of ' + maxlen + ' characters'
    msg_factory [i, maxlen], desc, title

  return
