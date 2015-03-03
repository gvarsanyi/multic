
fs     = require 'fs'
mkdirp = require 'mkdirp'

{expect, async} = require '../../test-base'

multic = require '../../js/multic'


coffee_code = """
x = (a) ->
  a + 1

"""

js_code = """
function x(a) {
  return a + 1;
}

"""


describe 'Processing pathes', ->

  it 'multic(source).coffee(cb)', (done) ->

    multic(coffee_code).coffee async done, (err, res) ->

      expect(err)
      .not.to.be.ok

      expect(res.source)
      .not.to.be.ok

      expect(res.compiled)
      .not.to.be.ok

      expect(res.minified)
      .not.to.be.ok


  it 'multic(source).file.coffee(cb)', (done) ->
    mkdirp 'tmp/', {mode: '0777'}, ->
      fs.writeFile 'tmp/api1.coffee', coffee_code, (err) ->

        multic('tmp/api1.coffee').file.coffee async done, (err, res) ->

          expect(err)
          .not.to.be.ok

          expect(res.source)
          .to.be.ok

          expect(res.compiled)
          .not.to.be.ok

          expect(res.minified)
          .not.to.be.ok


  it 'multic(source).coffee.js(cb)', (done) ->

    multic(coffee_code).coffee.js async done, (err, res) ->

      expect(err)
      .not.to.be.ok

      expect(res.source)
      .not.to.be.ok

      expect(res.compiled)
      .to.be.ok

      expect(res.minified)
      .not.to.be.ok


  it 'multic(source).file.coffee.js(cb)', (done) ->
    mkdirp 'tmp/', {mode: '0777'}, ->
      fs.writeFile 'tmp/api2.coffee', coffee_code, (err) ->

        multic('tmp/api2.coffee').file.coffee.js async done, (err, res) ->

          expect(err)
          .not.to.be.ok

          expect(res.source)
          .to.be.ok

          expect(res.compiled)
          .to.be.ok

          expect(res.minified)
          .not.to.be.ok


  it 'multic(source).coffee.js.min(cb)', (done) ->

    multic(coffee_code).coffee.js.min async done, (err, res) ->

      expect(err)
      .not.to.be.ok

      expect(res.source)
      .not.to.be.ok

      expect(res.compiled)
      .to.be.ok

      expect(res.minified)
      .to.be.ok


  it 'multic(source).file.coffee.js.min(cb)', (done) ->
    mkdirp 'tmp/', {mode: '0777'}, ->
      fs.writeFile 'tmp/api3.coffee', coffee_code, (err) ->

        multic('tmp/api3.coffee').file.coffee.js.min async done, (err, res) ->

          expect(err)
          .not.to.be.ok

          expect(res.source)
          .to.be.ok

          expect(res.compiled)
          .to.be.ok

          expect(res.minified)
          .to.be.ok


  it 'multic(source).js.min(cb)', (done) ->

    multic(js_code).js.min async done, (err, res) ->

      expect(err)
      .not.to.be.ok

      expect(res.source)
      .not.to.be.ok

      expect(res.compiled)
      .not.to.be.ok

      expect(res.minified)
      .to.be.ok


  it 'multic(source).file.js.min(cb)', (done) ->
    mkdirp 'tmp/', {mode: '0777'}, ->
      fs.writeFile 'tmp/api.js', js_code, (err) ->

        multic('tmp/api.js').file.js.min async done, (err, res) ->

          expect(err)
          .not.to.be.ok

          expect(res.source)
          .to.be.ok

          expect(res.compiled)
          .not.to.be.ok

          expect(res.minified)
          .to.be.ok
