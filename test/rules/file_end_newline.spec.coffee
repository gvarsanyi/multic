
{expect, async} = require '../../test-base'

multic = require '../../js/multic'


describe 'Rule: file_end_newline', ->

  it 'Warning on missing enter character', (done) ->

    code = """
    x = (a) ->
      a + 1
    """

    multic(code).coffee.js async done, (err, res) ->

      expect(err)
      .not.to.be.ok

      expect(warn = res.warnings[0])
      .to.be.ok

      expect(warn.sourceLines[warn.line]?.substr(warn.column - 1))
      .to.be.equal '1'


  it 'Warning on too many enter characters', (done) ->

    code = """
    x = (a) ->
      a + 1


    """

    multic(code).coffee.js async done, (err, res) ->

      expect(err)
      .not.to.be.ok

      expect(warn = res.warnings[0])
      .to.be.ok

      expect(warn.sourceLines[warn.line])
      .to.be.equal ''

      expect(warn.column)
      .to.be.equal 0

      expect(warn.sourceLines[warn.line])
      .to.be.equal ''

      expect(warn.sourceLines[warn.line - 1])
      .not.to.be.equal ''

      expect(warn.sourceLines[warn.line + 1])
      .to.be.equal ''

      expect(warn.sourceLines[warn.line + 2])
      .to.be.undefined

      expect(warn.message.indexOf())
      .not.to.be.equal ''


  it 'No warning when done right', (done) ->

    code = """
    x = (a) ->
      a + 1

    """

    multic(code).coffee.js async done, (err, res) ->

      expect(err or res.warnings[0])
      .not.to.be.ok
