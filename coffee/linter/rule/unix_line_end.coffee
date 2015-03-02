
module.exports.source = (msg_factory, source) ->

  if -1 < pos = source.indexOf '\r'

    desc = 'CR (\\r) character found'
    [line, col] = msg_factory.class.posByIndex source, pos

    msg_factory desc, line, col
