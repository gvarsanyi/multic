
module.exports =

  errors:
    #--- general
    unix_line_end:                      true

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
    no_line_end_whitespace:             true
    no_non_breaking_space:              0
    no_tabs:                            0

    #--- css + sass
    braces_spacing:                     0
    no_id_selectors:                    'ids'
    no_important_hack:                  'important'
    no_universal_selectors:             'universal-selector'
    no_unqualified_attribute_selectors: 'unqualified-attributes'

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
