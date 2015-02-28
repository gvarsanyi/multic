
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


describe 'Rule: img_src_required', ->

  describe 'Jade source', ->

    it 'Catches bad code: missing src attribute', (done) ->

      code2 = jade.replace 'src=\'x.jpg\'', ''
      multic(code2).jade.html async done, (err, res) ->

        expect(err)
        .not.to.be.ok

        expect(warn = res.warnings[0])
        .to.be.ok

        expect(warn.sourceLines[warn.line].substr(0, 8))
        .to.be.equal '    img('


    it 'Catches bad code: empty src attribute', (done) ->

      code2 = jade.replace 'src=\'x.jpg\'', 'src=\'\''
      multic(code2).jade.html async done, (err, res) ->

        expect(err)
        .not.to.be.ok

        expect(warn = res.warnings[0])
        .to.be.ok

        expect(warn.sourceLines[warn.line].substr(0, 8))
        .to.be.equal '    img('


    it 'No error/warning when done right', (done) ->

      multic(jade).jade.html async done, (err, res) ->

        expect(err or res.warnings[0])
        .not.to.be.ok


    it 'Can not turn rule off', (done) ->

      code2 = jade.replace 'src=\'x.jpg\'', 'src=\'\''
      opts  = {img_src_required: false}
      multic(code2, opts).jade.html async done, (err, res) ->

        expect(err)
        .not.to.be.ok

        expect(warn = res.warnings[0])
        .to.be.ok

        expect(warn.sourceLines[warn.line].substr(0, 8))
        .to.be.equal '    img('


  describe 'HTML source', ->

    it 'Catches bad code: missing src attribute', (done) ->

      code2 = html.replace 'src=\'x.jpg\'', ''
      multic(code2).html async done, (err, res) ->

        expect(err)
        .not.to.be.ok

        expect(warn = res.warnings[0])
        .to.be.ok

        expect(warn?.sourceLines[warn.line]?.substr(warn.column, 4))
        .to.equal '<img'


    it 'Catches bad code: empty src attribute', (done) ->

      code2 = html.replace 'src=\'x.jpg\'', 'src=\'\''
      multic(code2).html async done, (err, res) ->

        expect(err)
        .not.to.be.ok

        expect(warn = res.warnings[0])
        .to.be.ok

        expect(warn.sourceLines[warn.line]?.substr(warn.column, 4))
        .to.be.equal '<img'


    it 'No error/warning when done right', (done) ->

      multic(html).html async done, (err, res) ->

        expect(err or res.warnings[0])
        .not.to.be.ok
