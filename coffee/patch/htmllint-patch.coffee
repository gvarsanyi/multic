
Issue = null # assign it as needed


# fix buggy 'html-req-lang' rule

rule = require '../../node_modules/htmllint/lib/rules/html-req-lang'

rule.lint = (element, opts) ->
  unless opts[@name] and not element?.attribs?.lang?.value
    return []

  Issue ?= require '../../node_modules/htmllint/lib/issue'
  new Issue 'E025', element.openLineCol
