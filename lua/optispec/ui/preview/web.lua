local M = {}

M.previews = {
  javascript = [[function greet() {
    console.log("Hello, World!");
}

greet();]],

  typescript = [[function greet(): void {
    console.log("Hello, World!");
}

greet();]],

  html = [[<!DOCTYPE html>
<html>
<head>
    <title>Hello World</title>
</head>
<body>
    <h1>Hello, World!</h1>
</body>
</html>]],

  css = [[body {
    font-family: Arial, sans-serif;
    background-color: #f0f0f0;
}

h1 {
    color: #333;
    text-align: center;
}]],

  vue = [[<template>
  <div>
    <h1>{{ message }}</h1>
  </div>
</template>

<script>
export default {
  data() {
    return {
      message: 'Hello, World!'
    }
  }
}
</script>]],

  react = [[import React from 'react';

function App() {
  return (
    <div>
      <h1>Hello, World!</h1>
    </div>
  );
}

export default App;]],

  angular = [[import { Component } from '@angular/core';

@Component({
  selector: 'app-root',
  template: '<h1>{{ title }}</h1>'
})
export class AppComponent {
  title = 'Hello, World!';
}]],

  svelte = [[<script>
  let name = 'World';
</script>

<h1>Hello, {name}!</h1>]],

  astro = [[---
const greeting = "Hello, World!";
---

<html>
  <body>
    <h1>{greeting}</h1>
  </body>
</html>]]
}

return M
