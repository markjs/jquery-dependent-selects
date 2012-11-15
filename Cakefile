fs = require 'fs'
{spawn, exec} = require 'child_process'

js_file_name = 'jquery.dependent-selects.js'
coffee_file_name = 'jquery.dependent-selects.coffee'

compileJS = (options = {}) ->
  console.log "Compiling #{coffee_file_name}..."
  exec "coffee --compile --bare #{coffee_file_name}"

task 'build', 'Build things', ->
  compileJS()

task 'watch', 'Watch things', ->
  compileJS()
  fs.watch coffee_file_name, ->
    compileJS()
