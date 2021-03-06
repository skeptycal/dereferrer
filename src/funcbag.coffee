exports.VERBOSE = 1
exports.INSTALL_TYPE = 'development'

exports.puts = (level, who) ->
  arguments[2] = "#{who}: #{arguments[2]}" if arguments?.length > 2 && who != ""
  msg = (val for val, idx in arguments when idx > 1)
  console.log.apply(console, msg) if level <= exports.VERBOSE

# From stackoverflow so it must be solid.
exports.uuid = ->
  buf = new Uint16Array(8)
  window.crypto.getRandomValues buf
  S4 = (num) ->
    ret = num.toString(16);
    ret = "0"+ret while (ret.length < 4)
    ret

  (S4(buf[0])+S4(buf[1])+"-"+S4(buf[2])+"-4"+S4(buf[3]).substring(1)+"-y"+S4(buf[4]).substring(1)+"-"+S4(buf[5])+S4(buf[6])+S4(buf[7]))

# Return a string or null on error.
exports.readFile = (file) ->
  content = null
  fp = new XMLHttpRequest()
  try
    fp.open "GET", file, false
    fp.send null
    content = fp.responseText
  catch e
    exports.puts 0, 'readFile', 'cannot load %s: %s', file, e

  content

exports.domFlash = (element, funcall) ->
  oldcolor = element.style.backgroundColor
  element.style.backgroundColor = 'red'
  try
    funcall()
  catch e
    alert "Error: #{e.message}"
    throw e
  finally
    element.style.backgroundColor = oldcolor


exports.isUnderTests = -> jasmine? || suiteSetup?


# In a packed extension, there is no 'debug.txt'. Thus we can distinguish
# whether we are in a 'developer' mode or in a usual installation.
if !exports.isUnderTests() && !exports.readFile 'debug.txt'
  exports.VERBOSE = 0
  exports.INSTALL_TYPE = 'other'
