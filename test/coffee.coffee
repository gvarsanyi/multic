
multic = require '../js/multic'

error = (msg...) ->
  console.error '[FAIL]', msg...
  process.exit 1


code = """
x = (a) ->
  a + 1
"""

# DESC

async_tests =
  'js': (next) ->
    multic.coffee(code).js (err, res) ->
      if err
        return error err
      if res.compiled.indexOf('->') > 1
        return error 'Compilation error'
      if res.compiled.split('\n').length < 3
        return error 'Not pretty'
      next()

  'js.min': (next) ->
    multic.coffee(code).js.min (err, res) ->
      if err
        return error err
      if res.compiled.indexOf('->') > 1
        return error 'Compilation error'
      if res.minified.split('\n').length > 1
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
