
fs     = require 'fs'
mkdirp = require 'mkdirp'

{expect, async} = require '../../test-base'

multic = require '../../js/multic'


coffee_code = """
x = (a) ->
  a + 1

"""


describe 'Promises and callbacks', ->

  it 'Callback argument must be a function if passed', ->

    expect(-> multic(coffee_code).coffee(->))
    .not.to.throw

    expect(-> multic(coffee_code).coffee())
    .not.to.throw

    expect(-> multic(coffee_code).coffee(undefined))
    .not.to.throw

    expect(-> multic(coffee_code).coffee(null))
    .not.to.throw

    expect(-> multic(coffee_code).coffee(''))
    .to.throw

    expect(-> multic(coffee_code).coffee('fsd'))
    .to.throw

    expect(-> multic(coffee_code).coffee(0))
    .to.throw

    expect(-> multic(coffee_code).coffee(1))
    .to.throw

    expect(-> multic(coffee_code).coffee(true))
    .to.throw

    expect(-> multic(coffee_code).coffee(false))
    .to.throw

    expect(-> multic(coffee_code).coffee({}))
    .to.throw


  it 'Ppromise is returned only when callback is not defined', ->

    expect(multic(coffee_code).coffee(->))
    .not.to.be.ok

    expect(promise = multic(coffee_code).coffee())
    .to.be.ok

    expect(promise.then)
    .to.be.ok


  it 'Promise resolution: success', (done) ->

    expect(promise = multic(coffee_code).coffee.js())
    .to.be.ok

    success = (res) ->
      expect(res.errors.length)
      .not.to.be.ok

      expect(res.compiled)
      .to.be.ok

    error = (err) ->
      expect(err) # should have error message in this case
      .to.be.ok

      expect('should not be here')
      .not.to.be.ok

    promise.then async(done, success), async(done, error)

  it 'Promise resolution: error', (done) ->

    expect(promise = multic('fds@@@').coffee.js())
    .to.be.ok

    success = (res) ->
      expect('should not be here')
      .not.to.be.ok

    error = (err) ->
      expect(err)
      .to.be.ok

      expect(err.res)
      .to.be.ok

      expect(err.res.errors[0])
      .to.equal err

    promise.then async(done, success), async(done, error)
