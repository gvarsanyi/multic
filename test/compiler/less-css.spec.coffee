
fs     = require 'fs'
mkdirp = require 'mkdirp'
path   = require 'path'

{expect, async} = require '../../test-base'

multic = require '../../js/multic'


code = """
@primary-color: #323232;

BODY {
  DIV {
    font: 1em;
  }
  color: @primary-color;
}

"""

code_inc = """
@primary-color: #f00;

SPAN { font-size: 13px; }

"""


opts = file: 'src/test.less'


describe 'Compiler: less-css', ->

  it 'compile', (done) ->

    multic(code, opts).less.css async done, (err, res) ->

      expect(err)
      .not.to.be.ok

      expect(res.compiled.indexOf('color: #323232;'))
      .not.to.equal -1, 'Not compiled'

      expect(res.compiled.split('\n').length)
      .to.be.gt 3, 'Not pretty'


  it 'error handling', (done) ->

    code2 = code + '\n   errorline}\n'
    multic(code2, opts).less.css async done, (err, res) ->

      expect(err)
      .to.be.ok

      expect(err.sourceLines?[err.line]?.substr(err.column))
      .to.be.equal 'e}'


  it 'inclusion', (done) ->
    mkdirp 'tmp/', {mode: '0777'}, (err) ->
      fs.writeFile 'tmp/_lessinc.less', code_inc, (err) ->

        code2 = code.split '\n'
        code2[1] = '@import \'../tmp/_lessinc\';'
        code2 = code2.join '\n'

        multic(code2, opts).less.css async done, (err, res) ->

          expect(err)
          .not.to.be.ok

          expect(res.compiled.indexOf('color: #ff0000;'))
          .not.to.equal -1, 'Not compiled with include'


  it 'include error handling', (done) ->
    mkdirp 'tmp/', {mode: '0777'}, (err) ->
      fs.writeFile 'tmp/_lessinc2.less', code_inc + 'ErrLn}\n', (err) ->

        code2 = code.split '\n'
        code2[1] = '@import \'../tmp/_lessinc2\';'
        code2 = code2.join '\n'

        multic(code2, opts).less.css async done, (err, res) ->

          expect(err)
          .to.be.ok

          expect(err.sourceLines[err.line]?.substr(err.column))
          .to.be.equal 'V {'
