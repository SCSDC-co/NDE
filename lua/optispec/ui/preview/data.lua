local M = {}

M.previews = {
  json = [[{
  "message": "Hello, World!",
  "status": "success",
  "data": {
    "greeting": "Hello",
    "target": "World"
  }
}]],

  yaml = [[greeting:
  message: "Hello, World!"
  language: "YAML"
  version: 1.2
  features:
    - human readable
    - data serialization]],

  toml = [[[greeting]
message = "Hello, World!"
language = "TOML"

[config]
version = "1.0"
enabled = true]],

  markdown = [[# Hello, World!

This is a **markdown** document.

## Features
- Easy to write
- Easy to read
- *Italic* and **bold** text

```bash
echo "Hello, World!"
```]],

  xml = [[<?xml version="1.0" encoding="UTF-8"?>
<greeting>
    <message>Hello, World!</message>
    <language>XML</language>
</greeting>]],

  sql = [[SELECT 'Hello, World!' as message;

CREATE TABLE greetings (
    id INT PRIMARY KEY,
    message VARCHAR(255)
);

INSERT INTO greetings VALUES (1, 'Hello, World!');]],

  prisma = [[model User {
  id    Int    @id @default(autoincrement())
  name  String
  email String @unique
}

// Hello, World! in Prisma schema]],

  tex = [[\documentclass{article}
\begin{document}
\title{Hello, World!}
\author{OptiSpec}
\maketitle

Hello, World! This is \LaTeX.
\end{document}]]
}

return M
