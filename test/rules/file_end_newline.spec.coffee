
fs     = require 'fs'
mkdirp = require 'mkdirp'
path   = require 'path'

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


  it 'Catches issue in jade include', (done) ->
    mkdirp 'tmp/', {mode: '0777'}, (err) ->

      code = """
      doctype html
      html(lang="en")
        head
          title pageTitle
        body.class1.class2
          h1#id1.class3 xxx
          include ../tmp/_file_end_newline

      """

      code_inc = """
      span#hello
        | Hello
      """ # <- missing enter here

      fs.writeFile 'tmp/_file_end_newline.jade', code_inc, (err) ->

        multic(code, {file: 'src/x.jade'}).jade.html async done, (err, res) ->

          expect(err)
          .not.to.be.ok

          expect(warn = res.warnings[0])
          .to.be.ok

          expect(warn.sourceLines[warn.line]?.substr(warn.column - 5))
          .to.be.equal 'Hello'


  it 'Catches issue in sass include', (done) ->
    mkdirp 'tmp/', {mode: '0777'}, (err) ->

      code = """
      $primary-color: #333;

      @import '../tmp/_file_end_newline';

      BODY {
        DIV {
          font: 1em;
        }
        color: $primary-color;
      }

      """

      code_inc = """
      $primary-color: #f00;

      SPAN { font-size: 13px; }
      """ # <- missing enter here

      fs.writeFile 'tmp/_file_end_newline.scss', code_inc, (err) ->

        multic(code, {file: 'src/x.scss'}).sass.css async done, (err, res) ->

          expect(err)
          .not.to.be.ok

          expect(warn = res.warnings[0])
          .to.be.ok

          expect(warn.sourceLines[warn.line]?.substr(warn.column - 5))
          .to.be.equal 'px; }'
