
multic = require '../js/multic'

error = (msg...) ->
  console.error '[FAIL]', msg...
  process.exit 1


code = """
#id1.class1
  h1 Hello
"""

# DESC

async_tests =
  'js': (next) ->
    multic.jade(code).js (err, compiled, includes, warnings) ->
      if err
        return error err
      if compiled.indexOf('h1 Hello') > 1
        return error 'Compilation error'
      if compiled.split('\n').length < 3
        return error 'Not pretty'
      next()

  'js.min': (next) ->
    multic.jade(code).js.min (err, compiled, minified, includes, warnings) ->
      if err
        return error err
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
