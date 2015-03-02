
{expect, async} = require '../../test-base'

multic = require '../../js/multic'


code = """
"use strict";

var x = function (a) {
    return a + 1;
};


"""


describe 'Minifier: js', ->

  it 'minify', (done) ->

    multic(code).js.min async done, (err, res) ->

      expect(err)
      .not.to.be.ok

      expect(res.minified)
      .to.be.ok

      expect(res.minified.split('\n').length)
      .to.equal 1, 'Still pretty'
