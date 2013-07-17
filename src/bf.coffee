Tokenizer = require './tokenizer'
Interpreter = require './interpreter'

program = require 'commander'
split = require 'split'
fs = require 'fs'

program
  .version('0.0.0')
  .parse(process.argv)

fs.createReadStream(program.args[0])
  .pipe(split(//))
  .pipe(Tokenizer)
  .pipe(Interpreter)
