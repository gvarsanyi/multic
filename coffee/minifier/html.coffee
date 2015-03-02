
HtmlMinifier      = require 'html-minifier'
MinificationError = require '../error/minification-error'


module.exports = (inf, cb) ->

  try
    cfg =
      caseSensitive:             true
      keepClosingSlash:          true
      removeComments:            true
      removeCommentsFromCDATA:   true
      collapseWhitespace:        true
      conservativeCollapse:      true
      removeRedundantAttributes: true
      minifyJS:                  true
      minifyCSS:                 true

    inf.res.minified = HtmlMinifier.minify inf.source, cfg

  catch err

    if String(err).substr(0, 13) is 'Parse Error: '
      desc = 'Parse Error'
      if (part = String(err).substr 13).length and
      (idx = inf.source.indexOf part) > -1
        lines = inf.source.substr(0, idx).split '\n'
        pos = [lines.length - 1, lines.pop().length]

    inf.res.errors.push new MinificationError inf, err, pos, desc

  cb()