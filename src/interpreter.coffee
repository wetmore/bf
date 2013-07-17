Writable = require('stream').Writable
fs = require 'fs'

program = []
tape = new Buffer(30000)
tape.fill(0)
dp = 0
ip = 0

Interpreter = new Writable({ decodeStrings: false })

Interpreter._write = (data, encoding, next) ->
  program.push data.toString()
  next()

Interpreter.on 'finish', () ->
  parse(program, bracketMatches program)

module.exports = Interpreter

bracketMatches = (instructions) ->
  matches = {}
  stack = []
  # TODO errors
  instructions.forEach (char, index) ->
    if char is '[' then stack.push index
    if char is ']'
      matching = stack.pop()
      matches[index] = matching
      matches[matching] = index
  return matches

parse = (instructions, matches) ->
  until ip >= instructions.length
    switch instructions[ip]
      when '>' then dp++
      when '<' then dp--
      when '+' then tape[dp]++
      when '-' then tape[dp]--
      when '.' then process.stdout.write tape.toString('utf8', dp, dp + 1)
      when ','
        byte = 0
        try
          byte = fs.readSync(process.stdin.fd, tape, dp, 1)
        catch e
          if e.code is 'EAGAIN' # 'resource temporarily unavailable'
            # Happens on OS X 10.8.3 (not Windows 7!), if there's no
            # stdin input - typically when invoking a script without any
            # input (for interactive stdin input).
            # If you were to just continue, you'd create a tight loop.
            console.error 'ERROR: interactive stdin input not supported.'
            process.exit 1
          else if e.code is 'EOF'
            # Happens on Windows 7, but not OS X 10.8.3:
            # simply signals the end of *piped* stdin input.
            break
          throw e # unexpected exception
      when '['
        if tape[dp] == 0 then ip = matches[ip]
      when ']'
        if tape[dp] != 0 then ip = matches[ip]
    ip++
