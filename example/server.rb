require 'HTTP'
require 'UV'

s = UV::TCP.new()
s.bind(UV::ip4_addr('127.0.0.1', 8888))
s.listen(5) {|x|
  return if x != 0
  c = s.accept()
  c.read_start {|b|
    h = HTTP::Parser.new()
    h.parse(b) {|x|
      #c.write("HTTP/1.1 200 OK\r\nHost: localhost\r\n\r\nhello #{x.path}") {|r|
      c.write("HTTP/1.1 200 OK\r\nContent-Length: 6\r\n\r\nhello\n") {|r|
        c.close()
      }
    }
  }
}
UV::run()