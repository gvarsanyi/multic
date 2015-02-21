
multic = require '../js/multic'

error = (msg...) ->
  console.error '[FAIL]', msg...
  process.exit 1


code = """
doctype html
html(lang="en")
  head
    title pageTitle
  body.class1.class2
    h1#id1.class3 xxx
"""

# DESC

async_tests =
  'html': (next) ->
    multic.jade(code).html (err, compiled, includes, warnings) ->
      if err
        return error err
      if compiled.indexOf('(lang=') > -1
        return error 'Compilation error #1'
      unless compiled.split('>').length > 5
        return error 'Compilation error #2'
      unless compiled.indexOf('    <h1') > -1
        return error 'Not pretty'
      next()

  'html.min': (next) ->
    multic.jade(code).html.min (err, compiled, minified, includes, warnings) ->
      if err
        return error err
      if minified.indexOf('    <h1') > -1
        return error 'Remained pretty'
      next()


next_async = ->
  for name, test of async_tests
    delete async_tests[name]
    if test
      console.log 'Running async test:', name
      test next_async
    return
next_async()
