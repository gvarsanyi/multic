
{expect, async} = require '../../test-base'

multic = require '../../js/multic'


jade = """
span
  input(type='checkbox' id='chk')
  label(for='chk') hello

"""

html = """
<span>
  <input type='checkbox' id='chk'>
  <label for='chk'>hello</label>
</span>

"""


describe 'Rule: label_for_required', ->

  describe 'Jade source', ->

    it 'Catches bad code: missing for attribute', (done) ->

      code2 = jade.replace 'for=\'chk\'', ''
      multic(code2).jade.html async done, (err, res) ->

        expect(err)
        .not.to.be.ok

        expect(warn = res.warnings[0])
        .to.be.ok

        expect(warn.sourceLines[warn.line].substr(0, 8))
        .to.be.equal '  label('


    it 'Catches bad code: empty for attribute', (done) ->

      code2 = jade.replace 'for=\'chk\'', 'for=\'\''
      multic(code2).jade.html async done, (err, res) ->

        expect(err)
        .not.to.be.ok

        expect(warn = res.warnings[0])
        .to.be.ok

        expect(warn.sourceLines[warn.line].substr(0, 8))
        .to.be.equal '  label('


    it 'No error/warning when done right', (done) ->

      multic(jade).jade.html async done, (err, res) ->

        expect(err or res.warnings[0])
        .not.to.be.ok


    it 'Can not turn rule off', (done) ->

      code2 = jade.replace 'for=\'chk\'', 'for=\'\''
      opts  = {label_for_required: false}
      multic(code2, opts).jade.html async done, (err, res) ->

        expect(err)
        .not.to.be.ok

        expect(warn = res.warnings[0])
        .to.be.ok

        expect(warn.sourceLines[warn.line].substr(0, 8))
        .to.be.equal '  label('


  describe 'HTML source', ->

    it 'Catches bad code: missing for attribute', (done) ->

      code2 = html.replace 'for=\'chk\'', ''
      multic(code2).html async done, (err, res) ->

        expect(err)
        .not.to.be.ok

        expect(warn = res.warnings[0])
        .to.be.ok

        expect(warn?.sourceLines[warn.line]?.substr(warn.column, 6))
        .to.equal '<label'


    it 'Catches bad code: empty for attribute', (done) ->

      code2 = html.replace 'for=\'chk\'', 'for=\'\''
      multic(code2).html async done, (err, res) ->

        expect(err)
        .not.to.be.ok

        expect(warn = res.warnings[0])
        .to.be.ok

        expect(warn.sourceLines[warn.line]?.substr(warn.column, 6))
        .to.be.equal '<label'


    it 'No error/warning when done right', (done) ->

      multic(html).html async done, (err, res) ->

        expect(err or res.warnings[0])
        .not.to.be.ok
