
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


describe 'Rule: img_alt_required', ->

  describe 'Jade source', ->

    it 'Catches bad code: missing alt attribute', (done) ->

      code2 = jade.replace 'alt=\'hello\'', ''
      multic(code2).jade.html async done, (err, res) ->

        expect(err)
        .not.to.be.ok

        expect(warn = res.warnings[0])
        .to.be.ok

        expect(warn.sourceLines[warn.line].substr(0, 8))
        .to.be.equal '    img('


    it 'Accepts empty alt attribute', (done) ->

      code2 = jade.replace 'alt=\'hello\'', 'alt=\'\''
      multic(code2).jade.html async done, (err, res) ->

        expect(err or res.warnings[0])
        .not.to.be.ok


    it 'No error/warning when done right', (done) ->

      multic(jade).jade.html async done, (err, res) ->

        expect(err or res.warnings[0])
        .not.to.be.ok


    it 'Can not turn rule off', (done) ->

      code2 = jade.replace 'alt=\'hello\'', ''
      opts  = {img_alt_required: false}
      multic(code2, opts).jade.html async done, (err, res) ->

        expect(err)
        .not.to.be.ok

        expect(warn = res.warnings[0])
        .to.be.ok

        expect(warn.sourceLines[warn.line].substr(0, 8))
        .to.be.equal '    img('


  describe 'HTML source', ->

    it 'Catches bad code: missing alt attribute', (done) ->

      code2 = html.replace 'alt=\'hello\'', ''
      multic(code2).html async done, (err, res) ->

        expect(err)
        .not.to.be.ok

        expect(warn = res.warnings[0])
        .to.be.ok

        expect(warn?.sourceLines[warn.line]?.substr(warn.column, 4))
        .to.equal '<img'


    it 'Accepts empty alt attribute', (done) ->

      code2 = html.replace 'alt=\'hello\'', 'alt=\'\''
      multic(code2).html async done, (err, res) ->

        expect(err or res.warnings[0])
        .not.to.be.ok


    it 'No error/warning when done right', (done) ->

      multic(html).html async done, (err, res) ->

        expect(err or res.warnings[0])
        .not.to.be.ok
