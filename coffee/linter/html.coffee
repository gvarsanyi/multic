
LintError   = require '../error/lint-error'
LintWarning = require '../warning/lint-warning'
eol_eof     = require './common/eol-eof'
linter      = require 'htmllint'


lint_map =
  errors:
    #--- html + jade
    no_attribute_dupes:                ['attr-no-dup', 'id-no-dup']
    no_unsafe_attribute_characters:    'attr-no-unsafe-char'

  mandatory_warnings:
    #--- html + jade
    html_lang_required:                'html-req-lang'
    img_alt_required:                  'img-req-alt'
    img_src_required:                  'img-req-src'
    label_for_required:                'label-req-for'
    lowercase_tag_names:               'tag-name-lowercase'

  enabled_warnings:
    #--- general
    file_end_newline:                  true
    indentation:                       {name:  'indent-width',
                                        value: [false, 2, 4]}
    line_end:                          true
    line_end_whitespace:               true
    no_tabs:                           {name:  'indent-style',
                                        value: [false, 'spaces']}

    #--- html + jade
    quote_consistency:                 {name: 'attr-quote-style',
                                        value: [false, 'quoted']}

    #--- jade only
    no_comma_separated_attributes:     0

  disabled_warnings:
    #--- general
    max_line_length:                   true

    #--- html + jade
    no_implicit_attribute_value:       'attr-req-value'

  disabled_rules: ['attr-bans'
                   'attr-name-style'
                   'doctype-first'
                   'doctype-html5'
                   'href-style'
                   'id-class-no-ad'
                   'id-class-style'
                   'line-end-style'
                   'spec-char-escape'
                   'tag-bans'
                   'tag-self-close']


module.exports = (inf, cb) ->

  try
    cfg = # descriptions at: https://github.com/htmllint/htmllint/wiki/Options
      'attr-no-dup':         true # double attributes trigger error in jade
      'attr-no-unsafe-char': true
      'attr-quote-style':    'quoted' # TODO quote consistency
      'attr-req-value':      true
      'html-req-lang':       true
      'id-no-dup':           true # double attributes trigger error in jade
      'img-req-alt':         true
      'img-req-src':         true
      'indent-style':        'spaces'
      'label-req-for':       true
      # 'spec-char-escape':    true # this also trigger warnings about spaces
      'tag-name-lowercase':  true
      'tag-name-match':      true
      'indent-width':        false

    if (indent = inf.indentation) and
    parseInt(indent, 10) is Number(indent) and indent > 0
      cfg['indent-width'] = indent

    success = (warnings) ->
      try
        for msg in warnings
          pos = LintError.parsePos msg.line, msg.column, -1, -1
          desc = linter.messages.renderIssue msg
          title = 'Lint Warning' + if msg.code then ' (' + msg.code + ')' else ''
          inf.res.warnings.push new LintWarning inf, msg, pos, desc, title
      catch err
        inf.res.errors.push new LintError inf, err

      eol_eof inf

      cb()

    error = (err) ->
      inf.res.errors.push new LintError inf, err
      cb()

    (linter inf.source, cfg).then success, error

  catch err

    inf.res.errors.push new LintError inf, err
    cb()
