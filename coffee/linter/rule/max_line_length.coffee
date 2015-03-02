
module.exports.source = (msg_factory, source, rule_value) ->

  maxlen = rule_value
  if maxlen is true
    maxlen = 80
  else
    maxlen = parseInt maxlen, 10

  unless maxlen > 0
    return


  for line, i in source.split('\n') when line.length > maxlen

    desc = 'Line length exceeds allowed maximum of ' + maxlen + ' characters'

    msg_factory desc, i, maxlen

  return
