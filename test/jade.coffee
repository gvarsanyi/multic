
fs     = require 'fs'
mkdirp = require 'mkdirp'
path   = require 'path'
multic = require '../js/multic'
test   = require '../simple-test'


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


test
  'html': (cb) ->
    multic(code, opts).jade.html (err, res) ->
      if err
        cb err
      if res.compiled.indexOf('(lang=') > -1
        cb 'Compilation error #1'
      unless res.compiled.split('>').length > 5
        cb 'Compilation error #2'
      unless res.compiled.indexOf('    <h1') > -1
        cb 'Not pretty'
      cb()

  'html.min': (cb) ->
    multic(code, opts).jade.html.min (err, res) ->
      if err
        cb err
      if res.minified.indexOf('    <h1') > -1
        cb 'Remained pretty'
      cb()

  'html with include': (cb) ->
    mkdirp 'tmp/', {mode: '0777'}, (err) ->
      if err
        cb err

      fs.writeFile 'tmp/_jadeinc.jade', code_inc, (err) ->
        if err
          cb err

        code2 = code + '\n    include ../tmp/_jadeinc\n'
        multic(code2, opts).jade.html (err, res) ->
          if err
            cb err
          unless res.compiled.indexOf('lang=') > -1
            cb 'Missing part #1:', res.compiled
          unless res.compiled.indexOf('>Hello</span>') > -1
            cb 'Missing part #2:', res.compiled
          unless res.includes.length is 1
            cb '`includes` array length fail:', res.includes
            unless path.isAbsolute res.includes[0]
              cb 'include path is not absolute:', res.includes[0]
          cb()

  'error handling': (cb) ->
    code2 = code + '\n    include testdir/nonexisting\n'
    multic(code2, opts).jade.html (err, res) ->
      unless err
        cb 'Missing error'
      unless err.sourceLines?[err.line].indexOf('include testdir/nonexist') > 1
        cb 'Error code snippet is not a match:', err
      cb()

  'warning handling': (cb) ->
    code2 = code + '\n    span"ee"\n'
    multic(code2, opts).jade.html (err, res) ->
      if err
        cb err
      unless (warn = res.warnings[0]) or res.warnings.length > 1
        cb 'Should have received 1 warning'
      unless warn.sourceLines?[warn.line].indexOf('span"ee"') > 1
        cb 'Warning code snippet is not a match:', warn
      cb()

  'lint warnings': (cb) ->
    code2 = code + '\n    IMG(src="1.jpg")\n'
    multic(code2, opts).jade.html (err, res) ->
      if err
        cb err
      unless (warn = res.warnings[0]) and res.warnings.length is 2
        cb 'Should have received 1 warning'
      unless warn.sourceLines?[warn.line].indexOf('IMG') > 1
        cb 'Warning code snippet is not a match:', warn
      cb()
