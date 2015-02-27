
LintError   = require '../error/lint-error'
LintWarning = require '../warning/lint-warning'
eol_eof     = require './common/eol-eof'
linter      = require('jshint').JSHINT


lint_map =
  errors:
    #--- js + coffee
    duplicate_key:                     'duplicate_key'
    no_empty_elements:                 '!elision'

  mandatory_warnings:
    #--- js + coffee
    no_comparison_assignments:         '!boss'
    no_debugger:                       '!debug'
    no_deprecated_iterator:            '!iterator'
    no_deprecated_proto:               '!proto'
    no_eval:                           '!evil'
    no_native_prototype_extension:     'freeze'
    no_operator_parentheses:           'singleGroups'
    no_undefined:                      'undef'
    no_unused:                         'unused'

    #--- js only
    curly_braces_required:             'curly'
    no_comma_first_elements:           '!laxcomma'
    no_ctrlstruct_var:                 '!funcscope'
    no_late_definition:                'latedef'
    no_loop_functions:                 '!loopfunc'
    no_unsafe_line_break:              '!laxbreak'
    no_variable_shadowing:             '!shadow'
    no_with_statement:                 '!withstmt'
    semicolons_required:               ['!asi', '!lastsemic']
    strict_mode_required:              'globalstrict'
    valid_this_required:               '!validthis'


  enabled_warnings:
    #--- general
    file_end_newline:                  true
    indentation:                       {name: 'indent', value: [false, 2, 4]}
    line_end:                          true
    line_end_whitespace:               true
    no_tabs:                           0

    #--- js + coffee
    braces_spacing:                    0
    camel_case_classes:                'newcap'
    colon_assignment_spacing:          0
    no_arguments_caller_or_callee:     'noarg'
    no_interpolation_in_single_quotes: 0
    no_non_breaking_space:             'nonbsp'
    no_throwing_strings:               0
    no_unnecessary_brackets:           '!sub'
    quote_consistency:                 'quotmark'
    space_operators:                   0
    spacing_after_comma:               0
    typeof_value:                      '!notypeof'

    #--- js only
    no_type_unsafe_comparison:         ['eqeqeq', '!eqnull']
    wrap_immediately_called_function:  'immed'

  disabled_warnings:
    #--- general
    max_line_length:                   true

    #--- js + coffee
    camel_case_variables:              'camelcase'
    constructor_parentheses_required:  0
    no_comma_operator:                 'nocomma'
    no_plusplus:                       '!plusplus'

    #--- js only
    no_expression_looking_assignment:  '!expr'
    no_multiline_string:               '!multistr'

  disabled_rules: ['bitwise'
                   'es3'
                   'forin'
                   'immed'
                   'maxcomplexity'
                   'maxdepth'
                   'maxerr'
                   'maxlen'
                   'maxparams'
                   'maxstatements'
                   'moz'
                   'noempty'
                   'nonew'
                   'scripturl'
                   'strict'
                   'supernew']

allowed_globals = {}


module.exports = (inf, cb) ->

  try
    cfg = # see option descriptions at http://jshint.com/docs/options/
      curly:        true
      devel:        true
      freeze:       true
      globalstrict: true
      immed:        true
      latedef:      true
      noarg:        true
      node:         true
      nonbsp:       true
      nonew:        true
      quotmark:     true
      singleGroups: true
      undef:        true
      unused:       true

    if (indent = inf.indentation) and
    parseInt(indent, 10) is Number(indent) and indent > 0
      cfg.indent = indent

    if inf.es6
      cfg.esnext = true

    linter inf.source, cfg

    for msg in linter.data()?.errors or []
      pos = LintError.parsePos msg.line, msg.character, -1, -1

      if msg.code is 'W117' and inf.allowGlobals
        continue

      if msg.code?[0] is 'W'
        title = 'Lint Warning' + if msg.code then ' (' + msg.code + ')' else ''
        inf.res.warnings.push new LintWarning inf, msg, pos, msg.reason, title
      else
        title = 'Error' + if msg.code then ' (' + msg.code + ')' else ''
        inf.res.errors.push new LintError inf, msg, pos, msg.reason, title

    eol_eof inf

  catch err

    inf.res.errors.push new LintError inf, err

  cb()
