
fs     = require 'fs'
mkdirp = require 'mkdirp'

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


  it 'from file', (done) ->
    mkdirp 'tmp/', {mode: '0777'}, ->
      fs.writeFile 'tmp/code.coffee', code, (err) ->

        multic('tmp/code.coffee', opts).file.coffee.js async done, (err, res) ->

          expect(err)
          .not.to.be.ok

          expect(res.compiled.indexOf('->'))
          .to.be.equal -1, 'Not compiled'

          expect(res.compiled.split('\n').length)
          .to.be.gt 3, 'Not pretty'


  it 'lint from file', (done) ->
    mkdirp 'tmp/', {mode: '0777'}, (err) ->
      code2 = code + '\ny = () ->\n'
      fs.writeFile 'tmp/code.coffee', code2, (err) ->

        multic('tmp/code.coffee', opts).file.coffee async done, (err, res) ->

          expect(err)
          .not.to.be.ok

          expect(warn = res.warnings[0])
          .to.be.ok

          expect(warn.sourceLines[warn.line]?.substr(warn.column, 9))
          .to.be.equal 'y = () ->'
