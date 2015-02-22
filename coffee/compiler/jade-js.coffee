
jade2html = require './jade-html'
html2js   = require './html-js'


module.exports = (inf, cb) ->

  jade2html inf, ->
    if inf.res.errors.length
      return cb()

    inf.source = inf.res.compiled
    html2js inf, cb
