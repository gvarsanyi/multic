
module.exports =

  errors:
    #--- general
    unix_line_end:                  true

    #--- html + jade
    no_attribute_dupes:             ['attr-no-dup', 'id-no-dup']
    no_unsafe_attribute_characters: 'attr-no-unsafe-char'
    tag_name_match:                 'tag-name-match'

  mandatory_warnings:
    #--- html + jade
    html_lang_required:             'html-req-lang'
    img_alt_required:               'img-req-alt'
    img_src_required:               'img-req-src'
    label_for_required:             'label-req-for'
    lowercase_tag_names:            'tag-name-lowercase'

  enabled_warnings:
    #--- general
    file_end_newline:               true
    indentation:
      name:   'indent-width'
      values: [false, 2, 4]
    no_line_end_whitespace:         true
    no_non_breaking_space:          0
    no_tabs:
      name:   'indent-style'
      values: [false, 'spaces']

    #--- html + jade
    quote_consistency:
      name:   'attr-quote-style'
      values: [false, 'quoted']

  disabled_warnings:
    #--- general
    max_line_length:                true

    #--- html + jade
    no_implicit_attribute_value:    'attr-req-value'

  disabled_rules: ['attr-name-style'
                   'doctype-first'
                   'doctype-html5'
                   'href-style'
                   'id-class-no-ad'
                   'id-class-style'
                   'line-end-style'
                   'spec-char-escape'
                   'tag-self-close']
