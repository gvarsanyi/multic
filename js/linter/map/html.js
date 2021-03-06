// Generated by CoffeeScript 1.9.3
module.exports = {
  errors: {
    unix_line_end: true,
    no_attribute_dupes: ['attr-no-dup', 'id-no-dup'],
    no_unsafe_attribute_characters: 'attr-no-unsafe-char',
    tag_name_match: 0
  },
  mandatory_warnings: {
    html_lang_required: 'html-req-lang',
    img_alt_required: 'img-req-alt',
    img_src_required: 'img-req-src',
    label_for_required: 'label-req-for',
    lowercase_tag_names: 'tag-name-lowercase'
  },
  enabled_warnings: {
    file_end_newline: true,
    indentation: {
      name: 'indent-width',
      values: [false, 2, 4]
    },
    no_line_end_whitespace: true,
    no_non_breaking_space: 0,
    no_tabs: {
      name: 'indent-style',
      values: [false, 'spaces']
    },
    quote_consistency: {
      name: 'attr-quote-style',
      values: [false, 'quoted']
    }
  },
  disabled_warnings: {
    max_line_length: true,
    no_implicit_attribute_value: 'attr-req-value'
  },
  disabled_rules: ['attr-name-style', 'doctype-first', 'doctype-html5', 'href-style', 'id-class-no-ad', 'id-class-style', 'line-end-style', 'spec-char-escape', 'tag-self-close']
};
