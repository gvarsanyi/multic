
fs     = require 'fs'
mkdirp = require 'mkdirp'
path   = require 'path'

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


    it 'Catches issue in include', (done) ->
      mkdirp 'tmp/', {mode: '0777'}, (err) ->
        jade_inc_warn = 'img(src="y.jpg")\n'
        fs.writeFile 'tmp/_jadeinc_img_alt_req.jade', jade_inc_warn, (err) ->

          code2 = jade + '\n    include ../tmp/_jadeinc_img_alt_req\n'
          opts = {file: 'src/test.jade'}
          multic(code2, opts).jade.html async done, (err, res) ->

            expect(err)
            .not.to.be.ok

            expect(warn = res.warnings[0])
            .to.be.ok

            expect(warn.sourceLines[warn.line])
            .to.be.equal 'img(src="y.jpg")'


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
