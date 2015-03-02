
module.exports.map = (msg_factory, map) ->

  for node in map

    if typeof (name = node.name) is 'string' and name isnt name.toLowerCase()

      desc = 'Tag name should be lowercase: `' + name + '`'

      if node.line?
        line = node.line - 1

      msg_factory desc, line, null, node.filename

  return
