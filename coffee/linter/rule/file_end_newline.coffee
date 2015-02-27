
module.exports = (inf, source_type, msg_factory, title, lines) ->

  unless inf.source.substr(last = inf.source.length - 1) is '\n'

    desc = 'Missing enter character at end of file'
    pos = [lines.length - 1, lines[lines.length - 1].length]

    msg_factory pos, desc, title

  else

    last_count = 1
    while inf.source.substr(last - last_count, 1) is '\n'
      last_count += 1

    if last_count > 1

      desc = 'Unnecessary empty line' + (if last_count > 1 then 's' else '') +
             ' at end of file'
      pos = [lines.length - last_count, 0]

      msg_factory pos, desc, title
