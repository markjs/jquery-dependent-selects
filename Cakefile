fs = require 'fs'
{spawn, exec} = require 'child_process'

compileJS = (options = {}) ->
  exec 'coffee --compile jquery-dependent-selects.coffee', copyHeadComment

copyHeadComment = ->
  file_contents = fs.readFileSync('jquery-dependent-selects.js').toString('utf-8')
  coffee_file_contents = fs.readFileSync('jquery-dependent-selects.coffee').toString('utf-8')
  head_comment = []
  
  for line in coffee_file_contents.split('\n')
    if line[0] == "#"
      head_comment.push(line)

  if head_comment.length > 0
    head_comment = '/*\n' + head_comment.join('\n') + '\n*/\n\n'
  else
    head_comment = ''

  fs.writeFileSync('jquery-dependent-selects.js', head_comment + file_contents)

task 'build', 'Build things', ->
  compileJS()
