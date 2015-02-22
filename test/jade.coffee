
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
    multic.jade(code).html (err, res) ->
      if err
        return error err
      if res.compiled.indexOf('(lang=') > -1
        return error 'Compilation error #1'
      unless res.compiled.split('>').length > 5
        return error 'Compilation error #2'
      unless res.compiled.indexOf('    <h1') > -1
        return error 'Not pretty'
      next()

  'html.min': (next) ->
    multic.jade(code).html.min (err, res) ->
      if err
        return error err
      if res.minified.indexOf('    <h1') > -1
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
