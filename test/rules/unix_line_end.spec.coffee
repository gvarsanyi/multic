
{expect, async} = require '../../test-base'

multic = require '../../js/multic'


code = """
x = (a) ->
  a + 1

"""

describe 'Rule: unix_line_end', ->

  it 'Catches bad code: error level', (done) ->

    multic(code + '\r\n').coffee.js async done, (err, res) ->

      expect(err)
      .to.be.ok

      expect(err.sourceLines[err.line]?.substr(err.column))
      .to.be.equal '\r'


  it 'No error/warning when done right', (done) ->

    multic(code).coffee.js async done, (err, res) ->

      expect(err or res.warnings[0])
      .not.to.be.ok
