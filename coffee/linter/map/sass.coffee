
module.exports =

  errors:
    #--- general
    unix_line_end:                      true

  mandatory_warnings:
    #--- css + sass
    no_overqualified_elements:          0
    no_star_hack:                       0
    no_underscore_hack:                 0
    no_units_for_zero:                  0
    standard_property_required:         0

  enabled_warnings:
    #--- general
    file_end_newline:                   true
    indentation:                        0
    line_end_whitespace:                true
    no_tabs:                            0

    #--- css + sass
    braces_spacing:                     0
    no_id_selectors:                    0
    no_important_hack:                  0
    no_universal_selectors:             0
    no_unqualified_attribute_selectors: 0
    spacing_after_comma:                0

  disabled_warnings:
    #--- general
    max_line_length:                    true

    #--- css + sass
    no_outline_disabling:               0
    no_qualified_headings:              0
    shorthand_property_required:        0
    unique_headings:                    0
