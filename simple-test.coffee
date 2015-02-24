
error = (msg...) ->
  console.error '[FAIL]', msg...
  process.exit 1

process.on 'uncaughtException', error


module.exports = (tests) ->
  list = Object.keys tests or {}

  next_async = ->
    if (name = list.shift())?
      test = tests[name]
      if typeof test is 'function'
        console.log '  ->', name
        if String(String(test).split('(')[1]).split(')')[0].trim().length
          # has signiture -> ASYNC
          return test (err...) ->
            if err?.length
              error err...
            next_async()
        else # SYNC
          try
            test()
          catch err
            error err
      next_async()
    # DONE
  next_async()


module.exports.error = error
