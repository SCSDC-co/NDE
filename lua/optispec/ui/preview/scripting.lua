local M = {}

M.previews = {
  python = [[def main():
    print("Hello, World!")

main()]],

  javascript = [[console.log("Hello, World!");]],

  ruby = [[puts "Hello, World!"]],

  php = [[<?php
echo "Hello, World!";
?>]],

  shell = [[echo "Hello, World!"]],

  lua = [[print("Hello, World!")]],

  perl = [[print "Hello, World!\n";]],

  r = [[cat("Hello, World!\n")]],

  haskell = [[main = putStrLn "Hello, World!"]],

  ocaml = [[let () = print_endline "Hello, World!"]],

  clojure = [[(println "Hello, World!")]],

  erlang = [[-module(hello).
-export([hello_world/0]).

hello_world() ->
    io:format("Hello, World!\n").]],

  elixir = [[IO.puts "Hello, World!"]],

  elm = [[module Main exposing (main)

import Browser
import Html exposing (text)

main =
    Browser.sandbox { init = (), update = \_ -> (), view = \_ -> text "Hello, World!" }
]],

  gleam = [[import gleam/io

pub fn main() {
  io.println("Hello, World!")
}]],

  lean = [[def main : IO Unit :=
  IO.println "Hello, World!"]]
}

return M

