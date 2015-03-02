
{expect, async} = require '../../test-base'

multic = require '../../js/multic'


code = """
.class1.class2
  h1#id1.class3 xxx

"""


opts = file: 'src/testy.jade'


describe 'Compiler: jade-js (ng-html2js)', ->

  it 'compile, module name coming from file', (done) ->

    multic(code, opts).jade.js async done, (err, res) ->

      expect(err)
      .not.to.be.ok

      expect(res.compiled.indexOf('<h1'))
      .not.to.equal -1, 'Not compiled'

      expect(res.compiled.split('\n').length)
      .to.be.gt 3, 'Not pretty'

      expect(res.compiled.indexOf('module(\'testy\''))
      .to.be.gt -1, 'Module name not set right'


  it 'compile, module name configured', (done) ->

    multic(code, {moduleName: 'JoEjOe'}).jade.js async done, (err, res) ->

      expect(err)
      .not.to.be.ok

      expect(res.compiled.indexOf('module(\'JoEjOe\''))
      .to.be.gt -1, 'Module name not set right'
