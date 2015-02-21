
jade2html = require './jade-html'
html2js   = require './html-js'


module.exports = (inf, cb) ->

  jade2html inf, (err, compiled, includes1, warnings1) ->
    if err
      return cb err

    inf.source = compiled
    html2js inf, (err, compiled, includes2, warnings2) ->
      if err
        return cb err

      if includes1?.length or includes2?.length
        includes = (includes1 or []).concat includes2 or []

      if warnings1?.length or warnings2?.length
        warnings = (warnings1 or []).concat warnings2 or []

      cb null, compiled, includes, warnings
