
parser = require '../../jade-nodes-parser'


module.exports.map = (msg_factory, map) ->

  for node in parser.tagsWithNoAttrValue map, 'img', 'src'

    desc = '`img` tag needs `src` attribute with value'

    if node.line?
      line = node.line - 1

    msg_factory desc, line, null, node.filename

  return
