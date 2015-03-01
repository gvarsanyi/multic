
fs     = require 'fs'
mkdirp = require 'mkdirp'
path   = require 'path'

{expect, async} = require '../../test-base'

multic = require '../../js/multic'


code = """
doctype html
html(lang="en")
  head
    title pageTitle
  body.class1.class2
    h1#id1.class3 xxx

"""

code_inc = """
span#hello
  | Hello

"""


opts = file: 'src/test.jade'


describe 'Compiler: jade-html', ->

  it 'compile', (done) ->

    multic(code, opts).jade.html async done, (err, res) ->

      expect(err)
      .not.to.be.ok

      expect(res.compiled.indexOf('<h1'))
      .not.to.equal -1, 'Not compiled'

      expect(res.compiled.split('\n').length)
      .to.be.gt 3, 'Not pretty'


  it 'error handling', (done) ->

    code2 = code + '\n' + (err_part = '    include testdir/nonexisting') + '\n'
    multic(code2, opts).jade.html async done, (err, res) ->

      expect(err)
      .to.be.ok

      expect(err.sourceLines?[err.line]?.substr(err.column))
      .to.be.equal err_part


  it 'warning handling', (done) ->

    code2 = code + '\n    span"ee"\n'
    multic(code2, opts).jade.html async done, (err, res) ->

      expect(err)
      .not.to.be.ok

      expect(warn = res.warnings[0])
      .to.be.ok

      expect(warn.sourceLines[warn.line])
      .to.be.equal '    span"ee"'


  it 'inclusion', (done) ->
    mkdirp 'tmp/', {mode: '0777'}, (err) ->
      fs.writeFile 'tmp/_jadeinc.jade', code_inc, (err) ->

        code2 = code + '\n    include ../tmp/_jadeinc\n'
        multic(code2, opts).jade.html async done, (err, res) ->

          expect(err)
          .not.to.be.ok

          expect(res.compiled.indexOf('>Hello</span>'))
          .not.to.equal -1, 'Not compiled with include'


  it 'include error handling', (done) ->
    mkdirp 'tmp/', {mode: '0777'}, (err) ->
      fs.writeFile 'tmp/_jadeinc2.jade', code_inc + '\n  include xx\n', (err) ->

        code2 = code + '\n    include ../tmp/_jadeinc2\n'
        multic(code2, opts).jade.html async done, (err, res) ->

          expect(err)
          .to.be.ok

          expect(err.sourceLines[err.line]?.substr(err.column))
          .to.be.equal '  include xx'


  it 'include warning handling', (done) ->
    mkdirp 'tmp/', {mode: '0777'}, (err) ->
      fs.writeFile 'tmp/_jadeinc3.jade', code_inc + '\n  span"xx"\n', (err) ->

        code2 = code + '\n    include ../tmp/_jadeinc3\n'
        multic(code2, opts).jade.html async done, (err, res) ->

          expect(err)
          .not.to.be.ok

          expect(warn = res.warnings[0])
          .to.be.ok

          expect(warn.sourceLines[warn.line])
          .to.be.equal '  span"xx"'
