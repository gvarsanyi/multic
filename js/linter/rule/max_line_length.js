// Generated by CoffeeScript 1.9.1
module.exports = function(inf, source_type, msg_factory, title, lines) {
  var desc, i, j, len, line, maxlen;
  maxlen = inf.options.max_line_length;
  if (maxlen === true) {
    maxlen = 80;
  } else {
    maxlen = parseInt(maxlen, 10);
  }
  if (!(maxlen > 0)) {
    return;
  }
  for (i = j = 0, len = lines.length; j < len; i = ++j) {
    line = lines[i];
    if (!(line.length > maxlen)) {
      continue;
    }
    desc = 'Line length exceeds allowed maximum of ' + maxlen + ' characters';
    msg_factory([i, maxlen], desc, title);
  }
};