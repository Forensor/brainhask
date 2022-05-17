<div align="center"><img src="./res/brainhask-logo.png" height="150"></div>
<div><h3 align="center"><b>Brainhask</b></h3>

  <p align="center">
    <sup>Turing complete language interpreter. Based in <a href="https://en.wikipedia.org/wiki/Brainfuck">Brainf**k.</a></sup>
  </p>
</div>

## About Brainhask

Brainhask is a tiny interpreter for the [Brainf**k](https://en.wikipedia.org/wiki/Brainfuck) language. It features an **inline/file input interpreter**, and a **REPL**.

As the original language, Brainhask has only eight commands based in the following characters:

<table class="wikitable">

<tbody><tr>
<th style="text-align:center;">Character
</th>
<th align="left">Meaning
</th></tr>
<tr>
<td style="text-align:center"><code>&gt;</code>
</td>
<td>Increment the <a href="/wiki/Pointer_(computer_programming)" title="Pointer (computer programming)">data pointer</a> (to point to the next cell to the right).
</td></tr>
<tr>
<td style="text-align:center"><code>&lt;</code>
</td>
<td>Decrement the data pointer (to point to the next cell to the left).
</td></tr>
<tr>
<td style="text-align:center"><code>+</code>
</td>
<td>Increment (increase by one) the byte at the data pointer.
</td></tr>
<tr>
<td style="text-align:center"><code>-</code>
</td>
<td>Decrement (decrease by one) the byte at the data pointer.
</td></tr>
<tr>
<td style="text-align:center"><code>.</code>
</td>
<td>Output the byte at the data pointer.
</td></tr>
<tr>
<td style="text-align:center"><code>,</code>
</td>
<td>Accept one byte of input, storing its value in the byte at the data pointer.
</td></tr>
<tr>
<td style="text-align:center"><code>[</code>
</td>
<td>If the byte at the data pointer is zero, then instead of moving the <a href="/wiki/Program_Counter" class="mw-redirect" title="Program Counter">instruction pointer</a> forward to the next command, <a href="/wiki/Branch_(computer_science)" title="Branch (computer science)">jump</a> it <i>forward</i> to the command after the <i>matching</i> <code>]</code> command.
</td></tr>
<tr>
<td style="text-align:center"><code>]</code>
</td>
<td>If the byte at the data pointer is nonzero, then instead of moving the instruction pointer forward to the next command, jump it <i>back</i> to the command after the <i>matching</i> <code>[</code> command.
</td></tr></tbody></table>

## Getting Started

Install [create-elm-app](https://github.com/halfzebra/create-elm-app):

```cmd
npm install -g create-elm-app
```

Here are some useful commands:

### `elm-app start`

Run the app in development mode.
Open [http://localhost:3000](http://localhost:3000) to view it in the browser.

### `elm-app build`

Builds the app for production to the `build` folder.
It bundles Elm app and optimizes the build for the best performance.

The build is minified, and the filenames include the hashes.

## Future changes

TAI used to have a [minimax algorithm](https://en.wikipedia.org/wiki/Alpha%E2%80%93beta_pruning). I have tried to implement it in a functional way in Elm, but it took way too long to make the moves. In a close future I would like to add this to the project.

[Here](https://forensor.github.io/tai/)'s the legacy version including the AI.

## License

MIT © Álvaro
