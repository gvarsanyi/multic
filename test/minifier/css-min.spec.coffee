
{expect, async} = require '../../test-base'

multic = require '../../js/multic'


code = """
BODY {
  color: red;
}

DIV {
  font: 1em;
}

"""


describe 'Minifier: css', ->

  it 'minify', (done) ->

    multic(code).css.min async done, (err, res) ->

      expect(err)
      .not.to.be.ok

      expect(res.minified)
      .to.be.ok

      expect(res.minified.split('\n').length)
      .to.equal 1, 'Still pretty'
