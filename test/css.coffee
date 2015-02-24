
multic = require '../js/multic'
test   = require '../simple-test'


code = """

BODY {
  color: #fff;
  margin: 0;
}

"""


opts = file: 'src/test.css'


test
  'min': (cb) ->
    multic(code, opts).css.min (err, res) ->
      if err
        cb err
      if res.minified.indexOf('  ') > 1 or res.minified.split('\n').length > 1
        cb 'Remained pretty: ', res.minified
      cb()

  'error handling': (cb) ->
    code2 = code + '\nx@@@x\n\n'
    multic(code2, opts).css.min (err, res) ->
      unless err
        cb 'Missing error'
      unless res.errors[0]?.message?.indexOf('Broken declaration') > -1
        cb 'Error generation mismatch:', res
      cb()
