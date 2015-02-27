
module.exports =

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
