
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


describe 'Processing (writing to file)', ->

  it 'multic(source).coffee.js.write(target, cb)', (done) ->
    mkdirp 'tmp/', {mode: '0777'}, ->

      target = 'tmp/ftest1a.js'
      multic(coffee_code).coffee.js.write target, (err, res) ->

        fs.readFile target, {encoding: 'utf8'}, async done, (err2, data) ->
          expect(err or err2)
          .not.to.be.ok

          expect(data.length)
          .to.be.gt 5

          expect(res.compiled)
          .to.equal data


  it 'multic(source).coffee.file.js.write(target, cb)', (done) ->
    mkdirp 'tmp/', {mode: '0777'}, ->
      fs.writeFile 'tmp/fapi1.coffee', coffee_code, (err) ->

        target = 'tmp/ftest1b.js'
        multic('tmp/fapi1.coffee').file.coffee.js.write target, (err, res) ->

          fs.readFile target, {encoding: 'utf8'}, async done, (err2, data) ->
            expect(err or err2)
            .not.to.be.ok

            expect(data.length)
            .to.be.gt 5

            expect(res.compiled)
            .to.equal data


  it 'multic(source).coffee.js.min.write(target, cb)', (done) ->
    mkdirp 'tmp/', {mode: '0777'}, ->

      target = 'tmp/ftest2a.min.js'
      multic(coffee_code).coffee.js.min.write target, (err, res) ->

        fs.readFile target, {encoding: 'utf8'}, async done, (err2, data) ->
          expect(err or err2)
          .not.to.be.ok

          expect(data.length)
          .to.be.gt 5

          expect(res.minified)
          .to.equal data


  it 'multic(source).coffee.file.js.min.write(target, cb)', (done) ->
    mkdirp 'tmp/', {mode: '0777'}, ->
      fs.writeFile 'tmp/fapi2.coffee', coffee_code, (err) ->

        target = 'tmp/ftest2b.min.js'
        multic('tmp/fapi2.coffee').file.coffee.js.min.write target, (err, res) ->

          fs.readFile target, {encoding: 'utf8'}, async done, (err2, data) ->
            expect(err or err2)
            .not.to.be.ok

            expect(data.length)
            .to.be.gt 5

            expect(res.minified)
            .to.equal data


  it 'multic(source).js.min.write(target, cb)', (done) ->
    mkdirp 'tmp/', {mode: '0777'}, ->

      target = 'tmp/ftest3a.min.js'
      multic(js_code).js.min.write target, (err, res) ->

        fs.readFile target, {encoding: 'utf8'}, async done, (err2, data) ->
          expect(err or err2)
          .not.to.be.ok

          expect(data.length)
          .to.be.gt 5

          expect(res.minified)
          .to.equal data


  it 'multic(source).file.js.min.write(target, cb)', (done) ->
    mkdirp 'tmp/', {mode: '0777'}, ->
      fs.writeFile 'tmp/fapi3.js', js_code, (err) ->

        target = 'tmp/ftest3b.min.js'
        multic('tmp/fapi3.js').file.js.min.write target, (err, res) ->

          fs.readFile target, {encoding: 'utf8'}, async done, (err2, data) ->
            expect(err or err2)
            .not.to.be.ok

            expect(data.length)
            .to.be.gt 5

            expect(res.minified)
            .to.equal data
