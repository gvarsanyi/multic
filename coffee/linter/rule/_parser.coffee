
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

  cfg  = {}
  todo = []


  prop_lint = (rule_module, subtype, rule, level, file) ->
    title = rule[0].toUpperCase() + rule.substr(1).split('_').join ' '

    target    = {error: 'errors', warn: 'warnings'}[level]
    msg_class = {error: LintError, warn: LintWarning}[level]

    msg_factory = (desc, line, col, msg_file) ->
      mock = {}
      if msg_file ?= file
        mock.file = msg_file
      inf.res[target].push new msg_class inf, mock, [line, col], desc, title
    msg_factory.class = msg_class

    if subtype is 'map'
      multic_linter.map msg_factory, inf.sourceMap, inf.options[rule]
    else unless file?
      multic_linter.source msg_factory, inf.source, inf.options[rule]
    else if source = inf.includeSources?[file]
      multic_linter.source msg_factory, source, inf.options[rule]


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

          if multic_linter.map
            prop_lint multic_linter, 'map', rule, level

          if multic_linter.source
            prop_lint multic_linter, 'source', rule, level
            for file in inf.res.includes
              prop_lint multic_linter, 'source', rule, level, file

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
