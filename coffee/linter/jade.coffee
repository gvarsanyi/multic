# This module attempts to fill the gap between htmllint and missing lint-like
# warnings of jade compiler


LintError     = require '../error/lint-error'
LintWarning   = require '../warning/lint-warning'
eol_eof       = require './common/eol-eof'
jade_compiler = require '../compiler/jade-html'


module.exports = (inf, cb) ->

  inf.jadeNodes = []
  jade_compiler inf, ->
    inf.compiledJade = inf.res.compiled
    delete inf.res.compiled

    if inf.res.errors.length
      return cb()

    try
      warn = (desc, val) ->
        pos = LintWarning.parsePos node.line, null, -1
        if val
          desc += ': `' + val + '`'
        inf.res.warnings.push new LintWarning inf, {}, pos, desc, 'Lint Warning'

      req_attr = (attr_name, msg) ->
        found = false
        for attr in attrs
          if String(attr.name).toLowerCase() is attr_name and attr.val
            found = true
            break
        unless found
          warn msg, name

      for node in inf.jadeNodes
        {name, attrs, attributeNames} = node

        # rule: tag-name-lowercase
        if typeof name is 'string' and name isnt name.toLowerCase()
          warn 'Tag name should be lowercase', name
        name = name?.toLowerCase()

        switch name

          when 'html'
            # rule: html-req-lang
            req_attr 'lang', 'tag has no lang=\'lang-RGN\' attribute value'

          when 'img'
            # rule: img-req-alt
            req_attr 'alt', 'tag has no alt=\'text for image\' attribute value'

            # rule: img-req-src
            req_attr 'src', 'tag has no src=\'image-url\' attribute value'

          when 'label'
            req_attr 'for', 'tag has no for=\'element-id\' attribute value'

      # TODO attr-no-unsafe-char
      # TODO quote consistency
      # TODO indent-style
      # TODO indent-width

      eol_eof inf

    catch err

      inf.res.errors.push new LintError inf, err

    cb()
