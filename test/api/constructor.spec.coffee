
fs     = require 'fs'
mkdirp = require 'mkdirp'

{expect, async} = require '../../test-base'

multic = require '../../js/multic'


coffee_code = """
x = (a) ->
  a + 1

"""


describe 'Constructor', ->

  it '`source` must be a valid string', ->

    expect(-> multic(coffee_code))
    .not.to.throw

    expect(-> multic(''))
    .to.throw

    expect(-> multic(0))
    .to.throw

    expect(-> multic(1))
    .to.throw

    expect(-> multic(true))
    .to.throw

    expect(-> multic(false))
    .to.throw

    expect(-> multic({}))
    .not.to.throw

    expect(-> multic(null))
    .to.throw

    expect(-> multic(undefined))
    .to.throw

    expect(-> multic())
    .to.throw


  it '`options` must be an object when passed', ->

    expect(-> multic(coffee_code, true))
    .to.throw

    expect(-> multic(coffee_code, false))
    .to.throw

    expect(-> multic(coffee_code, 0))
    .to.throw

    expect(-> multic(coffee_code, 1))
    .to.throw

    expect(-> multic(coffee_code, ''))
    .to.throw

    expect(-> multic(coffee_code, 'fsdfsd'))
    .to.throw

    expect(-> multic(coffee_code, {}))
    .not.to.throw

    expect(-> multic(coffee_code, null))
    .not.to.throw

    expect(-> multic(coffee_code, undefined))
    .not.to.throw

    expect(-> multic(coffee_code))
    .not.to.throw


  it '`options.file` must be a string with value when passed', ->

    expect(-> multic(coffee_code, {file: 'hello.coffee'}))
    .not.to.throw

    expect(-> multic(coffee_code, {file: null}))
    .not.to.throw

    expect(-> multic(coffee_code, {file: undefined}))
    .not.to.throw

    expect(-> multic(coffee_code, {file: ''}))
    .to.throw

    expect(-> multic(coffee_code, {file: 0}))
    .to.throw

    expect(-> multic(coffee_code, {file: 1}))
    .to.throw

    expect(-> multic(coffee_code, {file: true}))
    .to.throw

    expect(-> multic(coffee_code, {file: false}))
    .to.throw

    expect(-> multic(coffee_code, {file: {}}))
    .to.throw

