
{expect, async} = require '../../test-base'

multic = require '../../js/multic'


code = """
x = (a) ->
  a + 1

"""

describe 'Rule: no_line_end_whitespace', ->

  it 'Catches bad code: white-space-only line', (done) ->

    multic(code + '   \n').coffee.js async done, (err, res) ->

      expect(err)
      .not.to.be.ok

      expect(warn = res.warnings[0])
      .to.be.ok

      expect(warn.sourceLines[warn.line]?.substr(warn.column))
      .to.be.equal '   '


  it 'Catches bad code: white space at end of line', (done) ->

    multic(code.replace('->', '->  ')).coffee.js async done, (err, res) ->

      expect(err)
      .not.to.be.ok

      expect(warn = res.warnings[0])
      .to.be.ok

      expect(warn.sourceLines[warn.line]?.substr(warn.column))
      .to.be.equal '  '


  it 'No warning when done right', (done) ->

    multic(code).coffee.js async done, (err, res) ->

      expect(err or res.warnings[0])
      .not.to.be.ok
