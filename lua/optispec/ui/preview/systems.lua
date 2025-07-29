local M = {}

M.previews = {
  rust = [[fn main() {
    println!("Hello, World!");
}]],

  go = [[package main

import "fmt"

func main() {
    fmt.Println("Hello, World!")
}]],

  clangs = [[#include <stdio.h>

int main() {
    printf("Hello, World!\n");
    return 0;
}]],

  zig = [[const std = @import("std");

pub fn main() void {
    std.debug.print("Hello, World!\n", .{});
}]],

  java = [[public class HelloWorld {
    public static void main(String[] args) {
        System.out.println("Hello, World!");
    }
}]],

  kotlin = [[fun main() {
    println("Hello, World!")
}]],

  scala = [[object HelloWorld extends App {
    println("Hello, World!")
}]],

  csharp = [[using System;

class Program {
    static void Main() {
        Console.WriteLine("Hello, World!");
    }
}]]
}

return M
