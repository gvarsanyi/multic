
{expect, async} = require '../../test-base'

multic = require '../../js/multic'


code = """
x = (a) ->
  a + 1
"""


opts = file: 'src/test.coffee'


describe 'Compiler: coffee-js', ->

  it 'compile', (done) ->

    multic(code, opts).coffee.js async done, (err, res) ->

      expect(err)
      .not.to.be.ok

      expect(res.compiled.indexOf('->'))
      .to.equal -1, 'Not compiled'

      expect(res.compiled.split('\n').length)
      .to.be.gt 3, 'Not pretty'


  it 'error handling', (done) ->

    code2 = code + '\n  x = <-\n'
    multic(code2, opts).coffee.js async done, (err, res) ->

      expect(err)
      .to.be.ok

      expect(err.sourceLines[err.line]?.substr(err.column))
      .to.be.equal '<-'
