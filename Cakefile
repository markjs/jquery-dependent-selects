fs = require 'fs'
{spawn, exec} = require 'child_process'

compileJS = (options = {}) ->
  exec 'coffee --compile --bare jquery-dependent-selects.coffee', copyHeadComment

copyHeadComment = ->
  file_contents = fs.readFileSync('jquery-dependent-selects.js')
  coffee_file_contents = fs.readFileSync('jquery-dependent-selects.coffee').toString('utf-8')
  head_comment = []
  
  for line in coffee_file_contents.split('\n')
    if line[0] == "#"
      head_comment.push(line)

  fs.writeFileSync('jquery-dependent-selects.js', '/*\n' + head_comment.join('\n') + '\n*/\n\n'
                   + file_contents.toString())

task 'build', 'Build things', ->
  compileJS()
