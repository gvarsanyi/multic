
multic = require '../js/multic'

error = (msg...) ->
  console.error '[FAIL]', msg...
  process.exit 1


code = """
function x (a) {
   return a + 1;
}
"""

# DESC

async_tests =
  'min': (next) ->
    multic.js(code).min (err, res) ->
      if err
        return error err
      if res.minified.indexOf('+1}') < 0 or res.minified.split('\n').length > 1
        return error 'Remained pretty: ', res.minified
      next()


next_async = ->
  for name, test of async_tests
    delete async_tests[name]
    if test
      console.log 'Running async test:', name
      test next_async
    return
next_async()
