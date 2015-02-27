
LintError   = require '../error/lint-error'
LintWarning = require '../warning/lint-warning'
eol_eof     = require './common/eol-eof'
linter      = require('coffeelint').lint


lint_map =
  errors:
    #--- js + coffee
    duplicate_key:                     'duplicate_key'

  mandatory_warnings:
    #--- js + coffee
    no_comparison_assignments:         0
    no_debugger:                       'no_debugger'
    no_deprecated_iterator:            0
    no_deprecated_proto:               0
    no_eval:                           0
    no_native_prototype_extension:     0
    no_operator_parentheses:           0
    no_undefined:                      0
    no_unused:                         0

    #--- coffee only
    ensure_comprehensions:             'ensure_comprehensions'

  enabled_warnings:
    #--- general
    file_end_newline:                  true
    indentation:
      name:     'indentation'
      property: 'indentation'
      value:    [false, 2, 4]
    line_end:                          true
    line_end_whitespace:               true
    no_tabs:                           'no_tabs'

    #--- js + coffee
    braces_spacing:
      name:     'braces_spacing'
      property: 'spacing'
      values:   [false, 0, 1]
    camel_case_classes:                'camel_case_classes'
    colon_assignment_spacing:
      name:     'colon_assignment_spacing'
      property: ['spacing', 'left']
      values:   [false, 0]
    no_arguments_caller_or_callee:     0
    no_interpolation_in_single_quotes: 'no_interpolation_in_single_quotes'
    no_non_breaking_space:             0
    no_throwing_strings:               'no_throwing_strings'
    no_unnecessary_brackets:           0
    quote_consistency:                 'prefer_single_quotes'
    space_operators:                   'space_operators'
    spacing_after_comma:               'spacing_after_comma'
    typeof_value:                      0

    #--- coffee only
    arrow_spacing:                     'arrow_spacing'
    no_backticks:                      'no_backticks'
    no_empty_param_list:               'no_empty_param_list'
    no_implicit_braces:                'no_implicit_braces'
    no_trailing_semicolons:            'no_trailing_semicolons'
    no_unnecessary_fat_arrows:         'no_unnecessary_fat_arrows'
    prefer_english_operators:          'prefer_english_operator'

  disabled_warnings:
    #--- general
    max_line_length:                   true

    #--- js + coffee
    camel_case_variables:              0
    constructor_parentheses_required: 'empty_constructor_needs_parens'
    no_comma_operator:                 0
    no_plusplus:                       true

    #--- coffee only
    no_implicit_parentheses:           ['no_implicit_parentheses'
                                        'non_empty_constructor_needs_parens']

  disabled_rules: ['cyclomatic_complexity'
                   'line_endings'
                   'max_line_length'
                   'newlines_after_classes'
                   'no_empty_functions'
                   'no_stand_alone_at'
                   'no_trailing_whitespace'
                   'transform_messes_up_line_numbers']

allowed_globals = {}


module.exports = (inf, cb) ->

  try
    warn_level = {level: 'warn'}

    cfg = # see option descriptions at http://www.coffeelint.org/#options
      arrow_spacing:                warn_level
      braces_spacing:               warn_level
      duplicate_key:                {level: 'error'}
      camel_case_classes:           warn_level
      colon_assignment_spacing:     warn_level
      no_backticks:                 warn_level
      no_debugger:                  warn_level
      no_empty_param_list:          warn_level
      no_implicit_braces:           warn_level
      no_interpolation_in_single_quotes: warn_level
      no_plusplus:                  warn_level
      no_tabs:                      warn_level
      no_throwing_strings:          warn_level
      no_trailing_semicolons:       warn_level
      no_unnecessary_double_quotes: warn_level
      no_unnecessary_fat_arrows:    warn_level
      prefer_english_operator:      warn_level
      prefer_single_quotes:         warn_level
      space_operators:              warn_level
      spacing_after_comma:          warn_level
      no_trailing_whitespace:       {level: 'ignore'} # handled by eol_eof
      max_line_length:              {level: 'ignore'} # handled by eol_eof

    for msg in linter inf.source, cfg
      rule = if msg.rule then '[' + msg.rule + '] ' else ''

      if typeof msg.message is 'string'
        if msg.message.substr(0, 7) is '[stdin]'
          parts = msg.message.split(' ')
          [line, col] = parts[0].substr(8).split ':'
          msg.message = parts[1 ...].join ' '

        msg.message = msg.message.split('\u001b')[0]
        if (pos = msg.message.lastIndexOf '\n') > -1
          msg.message = msg.message.substr 0, pos

        if msg.description
          desc  = rule + msg.description.split('\n<pre>')[0]
          title = msg.message

      pos = LintError.parsePos (msg.lineNumber or line), col, -1, -1

      if msg.level is 'error'
        title ?= rule + 'Error'
        inf.res.errors.push new LintError inf, msg, pos, desc, title
      else
        title ?= rule + 'Lint warning'
        inf.res.warnings.push new LintWarning inf, msg, pos, desc, title

    eol_eof inf

  catch err

    inf.res.errors.push new LintError inf, err

  cb()
