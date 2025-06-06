local home = os.getenv("HOME")
package.path = home .. "/.luarocks/share/lua/5.4/?.lua;" .. package.path
package.cpath = home .. "/.luarocks/lib/lua/5.4/?.so;" .. package.cpath
require "launch"
