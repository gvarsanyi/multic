
LintError   = require '../../error/lint-error'
LintWarning = require '../../warning/lint-warning'


levels =
  errors:             'error'
  mandatory_warnings: 'warn'
  enabled_warnings:   'warn'
  disabled_warnings:  'warn'
  disabled_rules:     'ignore'


module.exports = (inf, source_type, cb, next) ->

  map = require '../map/' + source_type

  factories =
    error: (pos, desc, title) ->
      inf.res.errors.push new LintError inf, {}, pos, desc, title
    warn: (pos, desc, title) ->
      inf.res.warnings.push new LintWarning inf, {}, pos, desc, title

  cfg  = {}
  todo = []

  for idea, rules of map

    for rule, ref of rules when ref isnt 0

      level = levels[idea]

      unless idea in ['errors', 'mandatory_warnings'] or
      (idea is 'enabled_warnings' and ((v = inf.options[rule]) or not v?)) or
      (idea is 'disabled_warnings' and inf.options[rule])
        level = 'ignore'

      if ref is true
        unless level is 'ignore'
          multic_linter = require './' + rule

          title = rule[0].toUpperCase() + rule.substr(1).split('_').join ' '

          (inf.ruleTmp[source_type] ?= {}).lines ?= inf.source.split '\n'

          multic_linter inf, source_type, factories[level], title,
                        inf.ruleTmp[source_type].lines

          if inf.res.errors.length
            return cb inf.res.errors[0]

        continue

      for item in (if Array.isArray(ref) then ref else [ref])
        if typeof item is 'string'
          name   = item
          keys   = null
          values = [false, true]
        else
          {name, property, values} = item
          keys = if Array.isArray(property) then property else [property]

        if name[0] is '!'
          name = name.substr 1
          if level is 'ignore'
            level = if idea is 'errors' then 'error' else 'warn'
          else
            level = 'ignore'

        if level is 'ignore'
          value = values[0]
        else
          value = values[1]
          if -1 < pos = values.indexOf inf.options[rule]
            value = values[pos]

        if source_type is 'coffee'
          cfg[name] = {level}
          if keys and value isnt true and value isnt false
            if keys.length is 2
              (cfg[name][keys[0]] ?= {})[keys[1]] = value
            else
              cfg[name][keys[0]] = value
        else
          cfg[name] = value

  next cfg
