
fs     = require 'fs'
mkdirp = require 'mkdirp'
multic = require '../js/multic'
path   = require 'path'
test   = require '../simple-test'


code = """
$primary-color: #333;

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
"""


opts = file: 'src/test.scss'


test
  'css': (cb) ->
    multic(code, opts).sass.css (err, res) ->
      if err
        cb err
      unless res.compiled.indexOf('color: #333;') > 1
        cb 'Variable not resolved right'
      cb()

  'css.min': (cb) ->
    multic(code, opts).sass.css.min (err, res) ->
      if err
        cb err
      unless res.compiled.indexOf('color: #333;') > 1
        cb 'Variable not resolved right'
      unless res.minified.indexOf('{color:#333}') > 1
        cb 'Variable not resolved right'
      cb()

  'css with include': (cb) ->
    mkdirp 'tmp/', {mode: '0777'}, (err) ->
      if err
        cb err

      fs.writeFile 'tmp/_sassinc.scss', code_inc, (err) ->
        if err
          cb err

        code2 = code.split '\n'
        code2[1] = '@import \'../tmp/_sassinc\';'
        code2 = code2.join '\n'

        multic(code2, opts).sass.css (err, res) ->
          if err
            cb err
          unless res.compiled.indexOf('color: #f00;') > 1
            cb 'Import did not kick in'
          cb()
