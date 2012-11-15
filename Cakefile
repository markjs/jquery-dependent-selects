fs = require 'fs'
{spawn, exec} = require 'child_process'

compileJS = (options = {}) ->
  exec 'coffee --compile jquery-dependent-selects.coffee'

task 'build', 'Build things', ->
  compileJS()
