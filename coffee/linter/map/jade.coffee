
module.exports =

  errors:
    #--- general
    unix_line_end:                  true

    #--- html + jade
    # no_attribute_dupes:             -1 # jade compiler, unknown-rule-name
    no_unsafe_attribute_characters: 0

  mandatory_warnings:
    #--- html + jade
    html_lang_required:             true
    img_alt_required:               true
    img_src_required:               true
    label_for_required:             true
    lowercase_tag_names:            true

  enabled_warnings:
    #--- general
    file_end_newline:               true
    indentation:                    0
    line_end_whitespace:            true
    no_tabs:                        0

    #--- html + jade
    quote_consistency:              0

    #--- jade only
    no_comma_separated_attributes:  0

  disabled_warnings:
    #--- general
    max_line_length:                true

    #--- html + jade
    no_implicit_attribute_value:    0
