
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
    multic.coffee(code).js (err, compiled, includes, warnings) ->
      if err
        return error err
      if compiled.indexOf('->') > 1
        return error 'Compilation error'
      if compiled.split('\n').length < 3
        return error 'Not pretty'
      next()

  'js.min': (next) ->
    multic.coffee(code).js.min (err, compiled, minified, includes, warnings) ->
      if err
        return error err
      if compiled.indexOf('->') > 1
        return error 'Compilation error'
      if minified.split('\n').length > 1
        return error 'Remained pretty: ', minified
      next()


next_async = ->
  for name, test of async_tests
    delete async_tests[name]
    if test
      console.log 'Running async test:', name
      test next_async
    return
next_async()
