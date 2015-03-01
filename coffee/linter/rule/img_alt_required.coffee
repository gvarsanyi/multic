
parser = require '../../jade-nodes-parser'


module.exports = (inf, source_type, msg_factory, title) ->

  for node in parser.tagsWithNoAttrValue inf.jadeNodes, 'img', 'alt', true

    desc = '`img` tag needs `alt` attribute with value'
    if node.line?
      pos = node.line - 1

    msg_factory pos, desc, title, node.filename

  return
