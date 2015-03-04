
{expect, async} = require '../../test-base'

multic = require '../../js/multic'

MulticProcess = require '../../js/multic-process'


code = """
x = (a) ->
  a + 1
""" # <- has 1 warning


describe 'Cluster/Performance', ->

  it '1000 concurrent processes BEFORE starting cluster', (done) ->
    @timeout 30000

    expect(MulticProcess.clusterProxy)
    .to.be.undefined

    count = 0
    flush = (n) ->
      tx = (new Date).getTime()
      for i in [0 ... n]
        do (i) ->
          t0 = (new Date).getTime()
          multic(code).coffee.js.min (err, req) ->

            count += 1

            expect(req.compiled and req.minified)
            .to.be.ok

            expect(req.warnings[0])
            .to.be.instanceOf Error

            if i is n - 1
              expect(count)
              .to.equal n

              done()

    flush 1000


  it 'Starting cluster', ->

    multic.cluster()

    expect(typeof MulticProcess.clusterProxy)
    .to.equal 'function'


  it '1000 concurrent processes right after starting', (done) ->
    @timeout 30000

    expect(typeof MulticProcess.clusterProxy)
    .to.equal 'function'

    count = 0
    flush = (n) ->
      tx = (new Date).getTime()
      for i in [0 ... n]
        do (i) ->
          t0 = (new Date).getTime()
          multic(code).coffee.js.min (err, req) ->

            count += 1

            expect(req.compiled and req.minified)
            .to.be.ok

            expect(req.warnings[0])
            .to.be.instanceOf Error

            if i is n - 1
              expect(count)
              .to.equal n

              done()

    flush 1000


  it 'Cool-down (3s)', (done) ->
    @timeout 5000
    setTimeout done, 3000

  it '1000 concurrent processes after cool-down', (done) ->
    @timeout 30000

    expect(typeof MulticProcess.clusterProxy)
    .to.equal 'function'

    count = 0
    flush = (n) ->
      tx = (new Date).getTime()
      for i in [0 ... n]
        do (i) ->
          t0 = (new Date).getTime()
          multic(code).coffee.js.min (err, req) ->

            count += 1

            expect(req.compiled and req.minified)
            .to.be.ok

            expect(req.warnings[0])
            .to.be.instanceOf Error

            if i is n - 1
              expect(count)
              .to.equal n

              done()

    flush 1000


  it 'Stopping cluster', (done) ->
    @timeout 5000

    multic.stopCluster async done, ->

      expect(MulticProcess.clusterProxy)
      .to.be.undefined

    expect(MulticProcess.clusterProxy)
    .to.be.undefined


  it '1000 concurrent processes after stopping cluster', (done) ->
    @timeout 30000

    expect(MulticProcess.clusterProxy)
    .to.be.undefined

    count = 0
    flush = (n) ->
      tx = (new Date).getTime()
      for i in [0 ... n]
        do (i) ->
          t0 = (new Date).getTime()
          multic(code).coffee.js.min (err, req) ->

            count += 1

            expect(req.compiled and req.minified)
            .to.be.ok

            expect(req.warnings[0])
            .to.be.instanceOf Error

            if i is n - 1
              expect(count)
              .to.equal n

              done()

    flush 1000
