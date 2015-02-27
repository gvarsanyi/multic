
module.exports = (inf, source_type, msg_factory, title) ->

  for node in inf.jadeNodes

    if typeof (name = node.name) is 'string' and name isnt name.toLowerCase()

      desc = 'Tag name should be lowercase: `' + name + '`'

      pos = if node.line? then node.line - 1 else null

      msg_factory pos, desc, title

  return
