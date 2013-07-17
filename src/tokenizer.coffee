Stream = require 'stream'

Tokenizer = new Stream.Transform({ decodeStrings: false })
valid = [
  '>'
  '<'
  '+'
  '-'
  '.'
  ','
  '['
  ']'
]

Tokenizer._transform = (data, encoding, next) ->
  char = data
  if char in valid then @push char
  next()

module.exports = Tokenizer
