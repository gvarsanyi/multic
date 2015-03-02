
module.exports.source = (msg_factory, source) ->

  unless source.substr(last = source.length - 1) is '\n'

    desc = 'Missing enter character at end of file'
    lines = source.split '\n'
    msg_factory desc, lines.length - 1, lines[lines.length - 1].length

  else

    last_count = 1
    while source.substr(last - last_count, 1) is '\n'
      last_count += 1

    if last_count > 1

      desc = 'Unnecessary empty line' + (if last_count > 1 then 's' else '') +
             ' at end of file'

      msg_factory desc, source.split('\n').length - last_count, 0
