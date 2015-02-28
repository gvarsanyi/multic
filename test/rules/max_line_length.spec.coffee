
{expect, async} = require '../../test-base'

multic = require '../../js/multic'


code = """
x = (a) -> # this comment is way too long for 40 char limit, it's almost 80chr!
  a + 1

"""

describe 'Rule: unix_line_end', ->

  it 'Catches bad code', (done) ->

    multic(code, {max_line_length: 40}).coffee.js async done, (err, res) ->

      expect(err)
      .not.to.be.ok

      expect(warn = res.warnings[0])
      .to.be.ok

      expect(warn.sourceLines[warn.line]?.substr(warn.column, 5))
      .to.be.equal 'g for'


  it 'No error/warning when done right', (done) ->

    multic(code, {max_line_length: 80}).coffee.js async done, (err, res) ->

      expect(err or res.warnings[0])
      .not.to.be.ok


  it 'Value true is translated to 80 characters limit', (done) ->

    code2 = code.replace '80chr!', '80chr! xyz'
    multic(code2, {max_line_length: true}).coffee.js async done, (err, res) ->

      expect(err)
      .not.to.be.ok

      expect(warn = res.warnings[0])
      .to.be.ok

      expect(warn.sourceLines[warn.line]?.substr(warn.column))
      .to.be.equal 'xyz'


  it 'Not turned on by default', (done) ->

    code2 = code.replace '80chr!', '80chr! xyz jfdsljlfkdsjf lkjs jflksdj flk' +
                                  'xsdfdf xyz jfdsljlfkdsjf lkjs jflksdj flkk' +
                                  'xsdfdf xyz jfdsljlfkdsjf lkjs jflksdj flkj' +
                                  'xsdfdf xyz jfdsljlfkdsjf lkjs jflksdj flkj'

    multic(code2).coffee.js async done, (err, res) ->

      expect(err or res.warnings[0])
      .not.to.be.ok
