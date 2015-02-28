// Generated by CoffeeScript 1.9.1
var parser;

parser = require('../../jade-nodes-parser');

module.exports = function(inf, source_type, msg_factory, title) {
  var desc, i, len, node, pos, ref;
  ref = parser.tagsWithNoAttrValue(inf.jadeNodes, 'html', 'lang');
  for (i = 0, len = ref.length; i < len; i++) {
    node = ref[i];
    desc = '`html` tag needs `lang` attribute with value';
    if (node.line != null) {
      pos = node.line - 1;
    }
    msg_factory(pos, desc, title);
  }
};
