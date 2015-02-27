
LintError   = require '../error/lint-error'
LintWarning = require '../warning/lint-warning'
eol_eof     = require './common/eol-eof'
linter      = require('coffeelint').lint


lint_map =
  errors:
    duplicate_key: 'duplicate_key'

  mandatory_warnings:
    ensure_comprehensions:         'ensure_comprehensions'
    # no_comparison_assignments:     true
    no_debugger:                   'no_debugger'
    # no_deprecated_iterator:        true
    # no_deprecated_proto:           true
    # no_eval:                       true
    # no_native_prototype_extension: true
    # no_operator_parentheses:       true
    # no_undefined:                  true
    # no_unused:                     true

  enabled_warnings:
    file_end_newline:                  true
    indentation:                       'indentation'
    line_end:                          true
    line_end_whitespace:               true
    no_tabs:                           'no_tabs'
    arrow_spacing:                     'arrow_spacing'
    no_backticks:                      'no_backticks'
    no_empty_param_list:               'no_empty_param_list'
    no_implicit_braces:                'no_implicit_braces'
    no_trailing_semicolons:            'no_trailing_semicolons'
    no_unnecessary_fat_arrows:         'no_unnecessary_fat_arrows'
    prefer_english_operators:          'prefer_english_operator'
    # allowed_globals:                   true
    braces_spacing:                    'braces_spacing'
    camel_case_classes:                'camel_case_classes'
    colon_assignment_spacing:          'colon_assignment_spacing'
    # no_arguments_caller_or_callee:     true
    no_interpolation_in_single_quotes: 'no_interpolation_in_single_quotes'
    # no_non_breaking_space:             true
    no_throwing_strings:               'no_throwing_strings'
    # no_unnecessary_brackets:           true
    prefer_single_quotes:              'prefer_single_quotes'
    space_operators:                   'space_operators'
    spacing_after_comma:               'spacing_after_comma'
    # typeof_value:                      true

  disabled_warnings:
    max_line_length:                false
    no_implicit_parentheses:        ['no_implicit_parentheses'
                                     'non_empty_constructor_needs_parens']
    # camel_case:                     false
    empty_constructor_needs_parens: 'empty_constructor_needs_parens'
    # no_comma_operator:              false
    no_plusplus:                    false

  disabled_rules: ['cyclomatic_complexity'
                   'line_endings'
                   'max_line_length'
                   'newlines_after_classes'
                   'no_empty_functions'
                   'no_stand_alone_at'
                   'no_trailing_whitespace'
                   'transform_messes_up_line_numbers']


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
