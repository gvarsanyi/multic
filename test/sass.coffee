
multic = require '../js/multic'

error = (msg...) ->
  console.error '[FAIL]', msg...
  process.exit 1


code = """
$primary-color: #333;

BODY {
  DIV {
    font: 1em;
  }
  color: $primary-color;
}
"""

# DESC

async_tests =
  'css': (next) ->
    multic.sass(code).css (err, res) ->
      if err
        return error err
      unless res.compiled.indexOf('color: #333;') > 1
        return error 'Variable not resolved right'
      next()

  'css.min': (next) ->
    multic.sass(code).css.min (err, res) ->
      if err
        return error err
      unless res.compiled.indexOf('color: #333;') > 1
        return error 'Variable not resolved right'
      unless res.minified.indexOf('{color:#333}') > 1
        return error 'Variable not resolved right'
      next()


next_async = ->
  for name, test of async_tests
    delete async_tests[name]
    if test
      console.log 'Running async test:', name
      test next_async
    return
next_async()
