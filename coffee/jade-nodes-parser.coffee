
module.exports.attrHasValue = attr_has_value = (node, attr, forgiving) ->

  for attr_inf in node.attrs

    if String(attr_inf.name).toLowerCase() is attr

      if forgiving
        return true

      value = String(attr_inf.val).trim()

      if (value[0] is '\'' and value.substr(value.length - 1) is '\'') or
      (value[0] is '"' and value.substr(value.length - 1) is '"')
        value = value.substr(1, value.length - 2).trim()

      return !!value

  false


module.exports.findTags = find_tags = (nodes, tag) ->

  unless nodes._tags

    tags = nodes._tags = {}

    for node in nodes when tag_name = node.name?.toLowerCase()
      (tags[tag_name] ?= []).push node

  nodes._tags[tag] ?= []



module.exports.tagsWithNoAttrValue = (nodes, tag, attr, forgiving) ->

  res = []
  for node in find_tags nodes, tag
    unless attr_has_value node, attr, forgiving
      res.push node

  res
