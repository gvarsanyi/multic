Lint rules for multic
======================

*multic* attempts to fix the linting hell by:
- unifying similar lint rules
- using descriptive, human readable rule names
- producing standardized errors/warnings
- fixing the gap between linters


# Configurable lint rules

## Enabled by default
You may turn these rules off by passing `false` as value.

*rule*                             | coffee | js/es6 | jade | html | sass | css
---------------------------------- | :----: | :----: | :--: | :--: | :--: | :--:
file_end_newline                   | ✓      | ✓      | ✓    | ✓    | ✓    | ✓
indentation (values: *false*, 2=*true*, 4) | ✓ | ✓   | x    | ✓    | x    | x
no_line_end_whitespace             | ✓      | ✓      | ✓    | ✓    | ✓    | ✓
no_non_breaking_space              | x      | ✓      | x    | x    | x    | x
no_tabs                            | ✓      | x      | x    | ✓    | x    | x
quote_consistency                  | ✓      | ✓      | x    | ✓    |      |
braces_spacing                     | ✓      | x      |      |      | x    | x
camel_case_classes                 | ✓      | ✓      |      |      |      |
colon_assignment_spacing           | ✓      | x      |      |      |      |
no_arguments_caller_or_callee      | x      | ✓      |      |      |      |
no_interpolation_in_single_quotes  | ✓      | x      |      |      |      |
no_throwing_strings                | ✓      | x      |      |      |      |
no_unnecessary_brackets            | x      | ✓      |      |      |      |
space_operators                    | ✓      | x      |      |      |      |
spacing_after_comma                | ✓      | x      |      |      |      |
typeof_value                       | x      | ✓      |      |      |      |
arrow_spacing                      | ✓      |        |      |      |      |
no_backticks                       | ✓      |        |      |      |      |
no_empty_param_list                | ✓      |        |      |      |      |
no_implicit_braces                 | ✓      |        |      |      |      |
no_trailing_semicolons             | ✓      |        |      |      |      |
no_unnecessary_fat_arrows          | ✓      |        |      |      |      |
prefer_english_operators           | ✓      |        |      |      |      |
no_type_unsafe_comparison          |        | ✓      |      |      |      |
wrap_immediately_called_function   |        | ✓      |      |      |      |
no_comma_separated_attributes      |        |        | x    |      |      |
no_id_selectors                    |        |        |      |      | x    | ✓
no_important_hack                  |        |        |      |      | x    | ✓
no_universal_selectors             |        |        |      |      | x    | ✓
no_unqualified_attribute_selectors |        |        |      |      | x    | ✓
no_css_import                      |        |        |      |      |      | ✓

## Disabled by default
You may turn these rules on by passing `true` as value.

*rule*                             | coffee | js/es6 | jade | html | sass | css
---------------------------------- | :----: | :----: | :--: | :--: | :--: | :--:
max_line_length (values: *false*, *true*=*80*, integer>0) | ✓ | ✓ | ✓ | ✓ | ✓ | ✓
camel_case_variables               | x      | ✓      |      |      |      |
constructor_parentheses_required   | ✓      | x      |      |      |      |
no_comma_operator                  | x      | ✓      |      |      |      |
no_plusplus                        | ✓      | ✓      |      |      |      |
no_expression_looking_assignment   |        | ✓      |      |      |      |
no_multiline_string                |        | ✓      |      |      |      |
no_implicit_attribute_value        |        |        | x    | ✓    |      |
no_outline_disabling               |        |        |      |      | x    | ✓
no_qualified_headings              |        |        |      |      | x    | ✓
shorthand_property_required        |        |        |      |      | x    | ✓
unique_headings                    |        |        |      |      | x    | ✓

# Non-configurable rules
These rules can not be turned off or configured

## Errors
These issues will stop the processor

*rule*                             | coffee | js/es6 | jade | html | sass | css
---------------------------------- | :----: | :----: | :--: | :--: | :--: | :--:
unix_line_end                      | ✓      | ✓      | ✓    | ✓    | ✓    | ✓
duplicate_key                      | ✓      | ✓      |      |      |      |
no_empty_elements                  | ✓      | ✓      |      |      |      |
no_attribute_dupes                 |        |        | ✓    | ✓    |      |
no_unsafe_attribute_characters     |        |        | x    | ✓    |      |
tag_name_match                     |        |        |      | ✓    |      |

## Warnings

*rule*                             | coffee | js/es6 | jade | html | sass | css
---------------------------------- | :----: | :----: | :--: | :--: | :--: | :--:
no_comparison_assignments          | x      | ✓      |      |      |      |
no_debugger                        | ✓      | ✓      |      |      |      |
no_deprecated_iterator             | x      | ✓      |      |      |      |
no_deprecated_proto                | x      | ✓      |      |      |      |
no_eval                            | x      | ✓      |      |      |      |
no_native_prototype_extension      | x      | ✓      |      |      |      |
no_operator_parentheses            | x      | ✓      |      |      |      |
no_undefined                       | x      | ✓      |      |      |      |
no_unused                          | x      | ✓      |      |      |      |
ensure_comprehensions              | ✓      |        |      |      |      |
curly_braces_required              |        | ✓      |      |      |      |
no_comma_first_elements            |        | ✓      |      |      |      |
no_ctrlstruct_var                  |        | ✓      |      |      |      |
no_late_definition                 |        | ✓      |      |      |      |
no_loop_functions                  |        | ✓      |      |      |      |
no_unsafe_line_break               |        | ✓      |      |      |      |
no_variable_shadowing              |        | ✓      |      |      |      |
no_with_statement                  |        | ✓      |      |      |      |
semicolons_required                |        | ✓      |      |      |      |
strict_mode_required               |        | ✓      |      |      |      |
valid_this_required                |        | ✓      |      |      |      |
html_lang_required                 |        |        | ✓    | ✓    |      |
img_alt_required                   |        |        | ✓    | ✓    |      |
img_src_required                   |        |        | ✓    | ✓    |      |
label_for_required                 |        |        | ✓    | ✓    |      |
lowercase_tag_names                |        |        | ✓    | ✓    |      |
no_overqualified_elements          |        |        |      |      | x    | ✓
no_star_hack                       |        |        |      |      | x    | ✓
no_underscore_hack                 |        |        |      |      | x    | ✓
no_units_for_zero                  |        |        |      |      | x    | ✓
standard_property_required         |        |        |      |      | x    | ✓

# Symbols
*✓* = implemented
*x* = not yet implemented (coming in future versions)
