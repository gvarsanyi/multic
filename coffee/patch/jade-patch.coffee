
Jade = require 'jade'
path = require 'path'


# provide includes
Jade.Parser::_multicPatch_parseInclude = Jade.Parser::parseInclude
Jade.Parser::parseInclude = ->
  if Array.isArray @options?.includes
    tok   = @peek()
    ipath = path.resolve @resolvePath tok.val.trim(), 'include'

    unless ipath in @options.includes
      @options.includes.push ipath

  @_multicPatch_parseInclude()


# expose parsed nodes
Jade.Parser::_multicPatch_parseExpr = Jade.Parser::parseExpr
Jade.Parser::parseExpr = ->
  expr = @_multicPatch_parseExpr()

  if Array.isArray @options?.nodes
    @options?.nodes.push expr

  expr
