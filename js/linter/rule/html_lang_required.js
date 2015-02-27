// Generated by CoffeeScript 1.9.1
module.exports = function(inf, source_type, msg_factory, title) {
  var attr, desc, found, i, j, len, len1, node, pos, ref, ref1, ref2;
  ref = inf.jadeNodes;
  for (i = 0, len = ref.length; i < len; i++) {
    node = ref[i];
    if (((ref1 = node.name) != null ? ref1.toLowerCase() : void 0) === 'html') {
      found = false;
      ref2 = node.attrs;
      for (j = 0, len1 = ref2.length; j < len1; j++) {
        attr = ref2[j];
        if (String(attr.name).toLowerCase() === 'lang' && attr.val) {
          found = true;
          break;
        }
      }
      if (!found) {
        desc = '`html` tag needs `lang` attribute with value';
        pos = node.line != null ? node.line - 1 : null;
        msg_factory(pos, desc, title);
      }
    }
  }
};
