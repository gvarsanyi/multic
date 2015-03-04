
cluster = require 'cluster'
os      = require 'os'

MulticProcess = require './multic-process'


stopped     = null
workers     = {}
worker_list = []


module.exports.stop = (cb) ->
  # console.log 'stopping...'
  if stopped is true
    return cb?()

  if cb
    cluster.disconnect cb

  stopped = true
  delete MulticProcess.clusterProxy
  for id, node of workers
    try
      unless node.worker.suicide
        node.worker.disconnect()
  return


for k of cluster.settings
  return # has_other_cluster


cluster.setupMaster {exec: __dirname + '/worker.js'}

worker_message = (worker, msg) ->

  switch msg?.req

    when 'processed'
      # console.log '[master] worker #' + worker.id, 'processed:', msg.err, msg.res
      if cb = callbacks[msg.reqId]
        delete callbacks[msg.reqId]
        cb msg.err, msg.res

    when 'ready'
      workers[worker.id].ready = true
      # console.log '[master] worker #' + worker.id, 'is ready'
      worker_list.push worker
      # console.log 'worker list:', (node.id for node in worker_list)

    # else
    #   console.warn '[master] worker #' + worker.id, 'sent unknwon message:', msg

create_worker = ->
  worker = cluster.fork()
  worker_id = worker.id
  workers[worker_id] = {worker}
  do (worker, worker_id) ->
    worker.on 'message', (msg) ->
      worker_message worker, msg

    worker.on 'disconnect', ->
      # console.log '[master] worker #' + worker_id, 'disconnected'
      worker_list = (node for node in worker_list when node.id isnt worker_id)
      # console.log 'worker list:', (node.id for node in worker_list)
      delete workers[worker_id]
      unless stopped is true
        create_worker()

for i in [0 ... Math.max 4, os.cpus().length]
  create_worker()


req_id = 0
callbacks = {}
MulticProcess.clusterProxy = (inf) ->

  unless worker_list.length
    # console.log 'proxy not yet ready'
    return false

  worker_list.push worker = worker_list.shift()

  # console.log 'PROXIED!', '#' + worker.id, worker_list.length

  callbacks[req_id] = (err, res) =>

    for key in ['source', 'compiled', 'minified'] when res[key]?
      inf.res[key] = res[key]

    if Array.isArray res.includes
      inf.res.includes.push res.includes...

    for key in ['errors', 'warnings'] when Array.isArray res[key]
      for node in res[key]
        err = new Error node.message
        for node_key, value of node when key isnt 'message'
          err[node_key] = value
        inf.res[key].push err

    inf.finish()

  req_id += 1
  worker.send
    req:        'process'
    reqId:      req_id
    source:     inf.source
    options:    inf.options
    todo:       inf.todo
    sourceType: inf.sourceType
    targetType: inf.targetType

  true
