
{expect, async} = require '../../test-base'

multic = require '../../js/multic'


code = """
<html lang='en'>
<body>
  <div>x</div>
  <img src='x.jpg' alt='hello'>
</body>
</html>

"""


describe 'Minifier: html', ->

  it 'minify', (done) ->

    multic(code).html.min async done, (err, res) ->

      expect(err)
      .not.to.be.ok

      expect(res.minified)
      .to.be.ok

      expect(res.minified.split('\n').length)
      .to.equal 1, 'Still pretty'
