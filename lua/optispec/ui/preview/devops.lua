local M = {}

M.previews = {
  docker = [[FROM alpine:latest

RUN apk add --no-cache curl

WORKDIR /app

COPY . .

CMD ["echo", "Hello, World!"]
]],

  nix = [[{ pkgs ? import <nixpkgs> {} }:

pkgs.writeShellScriptBin "hello" ''
  echo "Hello, World!"
'']],

  terraform = [[provider "local" {}

resource "local_file" "hello" {
  filename = "hello.txt"
  content  = "Hello, World!"
}

output "greeting" {
  value = "Hello, World!"
}]],

  ansible = [[---
- name: Hello World Playbook
  hosts: localhost
  tasks:
    - name: Display greeting
      debug:
        msg: "Hello, World!"]],

  helm = [[apiVersion: v2
name: hello-world
version: 1.0.0

---
apiVersion: v1
kind: ConfigMap
metadata:
  name: hello-config
data:
  greeting: "Hello, World!"]],

  git = [[# Hello, World! Git Repository

## .gitignore
*.log
*.tmp

## README.md
echo "Hello, World!"

## commit message
git commit -m "feat: add hello world functionality"]],

  cmake = [[cmake_minimum_required(VERSION 3.10)

project(HelloWorld)

add_executable(hello hello.cpp)

# Hello, World! CMake project]],

  nushell = [[def hello [] {
    "Hello, World!"
}

hello]],

  thrift = [[service HelloService {
    string sayHello(1: string name)
}

struct Greeting {
    1: string message = "Hello, World!"
}]]
}

return M
