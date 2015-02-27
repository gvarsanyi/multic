
js_map = require './js'


for k1, v1 of js_map

  module.exports[k1] = {}

  for k2, v2 of v1
    module.exports[k1][k2] = v2


module.exports.mandatory_warnings.es6 = 'esnext'
