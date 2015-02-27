
LintError   = require '../error/lint-error'
LintWarning = require '../warning/lint-warning'
eol_eof     = require './common/eol-eof'
linter      = require('csslint').CSSLint.verify


lint_map =
  mandatory_warnings:
    #--- css + sass
    no_overqualified_elements:          'overqualified-elements'
    no_star_hack:                       'star-property-hack'
    no_underscore_hack:                 'underscore-property-hack'
    no_units_for_zero:                  'zero-units'
    standard_property_required:         'vendor-prefix'

  enabled_warnings:
    #--- general
    file_end_newline:                   true
    indentation:                        0
    line_end:                           true
    line_end_whitespace:                true
    no_tabs:                            0

    #--- css + sass
    braces_spacing:                     0
    no_id_selectors:                    'ids'
    no_important_hack:                  'important'
    no_universal_selectors:             'universal-selector'
    no_unqualified_attribute_selectors: 'unqualified-attributes'
    spacing_after_comma:                0

    #--- css only
    no_css_import:                      'import'

  disabled_warnings:
    #--- general
    max_line_length:                    true

    #--- css + sass
    no_outline_disabling:               'outline-none'
    no_qualified_headings:              'qualified-headings'
    shorthand_property_required:        'shorthand'
    unique_headings:                    'unique-headings'

  disabled_rules: ['adjoining-classes'
                   'box-sizing'
                   'bulletproof-font-face'
                   'compatible-vendor-prefixes'
                   'duplicate-background-images'
                   'fallback-colors'
                   'floats'
                   'font-faces'
                   'font-sizes'
                   'gradients'
                   'regex-selectors'
                   'text-indent']


module.exports = (inf, cb) ->

  try
    cfg = # see descriptions at: https://github.com/CSSLint/csslint/wiki/Rules
      'star-property-hack':       true # Disallow star hack
      'underscore-property-hack': true # Disallow underscore hack
      'import':                   true # Disallow @import
      'universal-selector':       true # Disallow universal selector
      'overqualified-elements':   true # Disallow overqualified elements
      'zero-units':               true # Disallow units for zero values
      'unqualified-attributes':  true # Disallow unqualified attribute selectors
      'ids':                      true # Disallow IDs in selectors
      'important':                true # Disallow !important
      'vendor-prefix':       true # Require standard property with vendor prefix

    data = linter inf.source, cfg

    for msg in data?.messages
      pos = LintError.parsePos msg.line, msg.col, -1, -1

      message = String(msg.message).split(' at line ')[0]
      desc = message
      title = msg.rule?.name
      if msg.type is 'error'
        inf.res.errors.push new LintError inf, msg, pos, desc, title
      else
        inf.res.warnings.push new LintWarning inf, msg, pos, desc, title

    eol_eof inf

  catch err

    inf.res.errors.push new LintError inf, err

  cb()
