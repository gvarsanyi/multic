
module.exports = (inf, source_type, msg_factory, title) ->

  for node in inf.jadeNodes

    if node.name?.toLowerCase() is 'img'

      found = false
      for attr in node.attrs
        if String(attr.name).toLowerCase() is 'alt' and attr.val
          found = true
          break

      unless found

        desc = '`img` tag needs `alt` attribute with value'
        pos = if node.line? then node.line - 1 else null

        msg_factory pos, desc, title

  return
