fs = require 'fs'
{spawn, exec} = require 'child_process'

js_file_name = 'jquery-dependent-selects.js'
coffee_file_name = 'jquery-dependent-selects.coffee'

compileJS = (options = {}) ->
  console.log "Compiling #{coffee_file_name}..."
  exec "coffee --compile --bare #{coffee_file_name}", copyHeadComment

copyHeadComment = ->
  file_contents = fs.readFileSync(js_file_name).toString('utf-8')
  coffee_file_contents = fs.readFileSync(coffee_file_name).toString('utf-8')
  head_comment = []
  
  for line in coffee_file_contents.split('\n')
    if line[0] == "#"
      head_comment.push(line)

  if head_comment.length > 0
    head_comment = '/*\n' + head_comment.join('\n') + '\n*/\n\n'
  else
    head_comment = ''

  fs.writeFileSync(js_file_name, head_comment + file_contents)

task 'build', 'Build things', ->
  compileJS()

task 'watch', 'Watch things', ->
  compileJS()
  fs.watch coffee_file_name, ->
    compileJS()
