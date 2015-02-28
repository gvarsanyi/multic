
{expect, async} = require '../../test-base'

multic = require '../../js/multic'


jade = """
html(lang='en')
  body
    div x
    img(src='x.jpg' alt='hello')

"""

html = """
<html lang='en'>
<body>
  <div>x</div>
  <img src='x.jpg' alt='hello'>
</body>
</html>

"""


describe 'Rule: html_lang_required', ->

  describe 'Jade source', ->

    it 'Catches bad code: missing lang attribute', (done) ->

      code2 = jade.replace 'lang=\'en\'', ''
      multic(code2).jade.html async done, (err, res) ->

        expect(err)
        .not.to.be.ok

        expect(warn = res.warnings[0])
        .to.be.ok

        expect(warn.sourceLines[warn.line])
        .to.be.equal 'html()'


    it 'Catches bad code: empty lang attribute', (done) ->

      code2 = jade.replace 'lang=\'en\'', 'lang=\'\''
      multic(code2).jade.html async done, (err, res) ->

        expect(err)
        .not.to.be.ok

        expect(warn = res.warnings[0])
        .to.be.ok

        expect(warn.sourceLines[warn.line])
        .to.be.equal 'html(lang=\'\')'


    it 'No error/warning when done right', (done) ->

      multic(jade).jade.html async done, (err, res) ->

        expect(err or res.warnings[0])
        .not.to.be.ok


    it 'Can not turn rule off', (done) ->

      code2 = jade.replace 'lang=\'en\'', 'lang=\'\''
      opts  = {html_lang_required: false}
      multic(code2, opts).jade.html async done, (err, res) ->

        expect(err)
        .not.to.be.ok

        expect(warn = res.warnings[0])
        .to.be.ok

        expect(warn.sourceLines[warn.line])
        .to.be.equal 'html(lang=\'\')'


  describe 'HTML source', ->

    it 'Catches bad code: missing lang attribute', (done) ->

      code2 = html.replace 'lang=\'en\'', ''
      multic(code2).html async done, (err, res) ->

        expect(err)
        .not.to.be.ok

        expect(warn = res.warnings[0])
        .to.be.ok

        expect(warn?.sourceLines[warn.line]?.substr(warn.column, 5))
        .to.equal '<html'


    it 'Catches bad code: empty lang attribute', (done) ->

      code2 = html.replace 'lang=\'en\'', 'lang=\'\''
      multic(code2).html async done, (err, res) ->

        expect(err)
        .not.to.be.ok

        expect(warn = res.warnings[0])
        .to.be.ok

        expect(warn.sourceLines[warn.line]?.substr(warn.column, 5))
        .to.be.equal '<html'


    it 'No error/warning when done right', (done) ->

      multic(html).html async done, (err, res) ->

        expect(err or res.warnings[0])
        .not.to.be.ok
