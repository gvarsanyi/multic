
chai = require 'chai'



module.exports.expect = chai.expect

module.exports.async = (done, next) ->

  (args...) ->
    try
      next args...
    catch e
      err = e
    finally
      done err
