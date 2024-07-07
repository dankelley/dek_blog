---
author: Dan Kelley
date: 2024-07-06
title: Setting up lazyvim
---

**Abstract.** I've been using lunarvim for a while, but learned (from my friend
Clark Richards) that it is no longer actively maintained. So, I decided to
consider other neovim distributions.  This posting describes how I set up
lazyvim, which I decided was my best choice.

# Decision process

First, I had a look at astronvim.  It seems to install easily, and I did not
run into problems with a few sample files (including the present markdown
file). Unfortunately, though, I saw error messages when I tried to edit R
files. I tried web searches on those messages (in a file called `query.lua`)
but got nowhere.

Then I tried web searches for alternatives.  I ran across a youtube video
[https://www.youtube.com/watch?v=bbHtl0Pxzj8](https://www.youtube.com/watch?v=bbHtl0Pxzj8)
that I found quite helpful.  It scored lazyvim the highest of four tested
distributions, but the others were nearly as high.  The deciding factor for me
was the author: it is the Folke Lemaitre,
[https://github.com/folke](https://github.com/folke) who is a simply superstar
in the neovim circles, having written the amazing `lazy` package plus much,
much more (over 2000 commits in the first 6 months of the year!).

# Setting up lazyvim

*Step 1. follow the general advice from lazyvim.org*

Visit
[http://www.lazyvim.org/installation](http://www.lazyvim.org/installation) and
and follow the steps described there.  (I named the backups as
`bak-for-lazyvim` instead of just `*.bak` as suggested, because this is not the
first thing I tried.)

*Step 2. install the R language server*

Instal the R language server by starting `nvim` and typing

```lua
:Mason
```

Then type 2 to get the LSP listing and move the cursor down to the item called
`r-languageserver` and pressing the `i` key.

*Step 3. set up the R-nvim plugin*

To use the wonderful `R-nvim` package
[https://github.com/R-nvim/R.nvim](https://github.com/R-nvim/R.nvim), create a
new file called `.config/nvim/lua/plugins/myplugins.lua` with contents as
follows.

```lua
return {
    -- add R-nvim
    { "R-nvim/R.nvim", lazy = false, R_assign = 2, },
}
```

*Step 4. set indentation for R*

Add the following to the `~/.config/nvim/lua/config/options.lua` file.

```lua
vim.o.tabstop = 4
vim.o.expandtab = true
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
```

This sets up the 4-space indentation that is the standard in the oce package
[www.github.com/dankelley/oce](www.github.com/dankelley/oce).

*Step 5. set the local leader to comma*

Add the following to the `~/.config/nvim/lua/config/options.lua` file to
set the local leader to the `,` character.

```lua
vim.g.maplocalleader = ","
```


This value of the local leader is recommended for
[https://github.com/R-nvim/R.nvim](https://github.com/R-nvim/R.nvim), and it is
quite popular in other situations, perhaps because it is much easier for
touch-typists to strike than the default value of `\`.

At this stage, it makes sense to open an existing .R file and then typing `,rf`
to see if a console window appears.  If not, there is a problem.  If so, then
try typing `,aa` to see if the source file is run by R.


*Step 6. set up python*

Type

```lua
.LazyExtras
```

and scroll down to find `formatting.black`.  If it is not listed as having been
already enabled, enable it by pressing `x` when the cursor is on that line.
This will create (or add to an existing) a `~/.config/nvim/lazyvim.json` file.

Then type

```lua
:Mason
```

to enter Mason, and type `4` to get to linters.  Scroll down until you find
`flake8` and type `i` to install it.

Still in Mason, type 2 to get to language server protocols (LSPs). Find the LSP
named `pyright` and install that.

To test this, edit some python code and add a line like

```python
junk=3
```

and then type `SPC c f` to format it.  Spaces should appear to the right and
left of the equals sign. Then remove the spaces again and type `:w` to write
the file.  This ought to run the formatter again, so the spaces will reappear.
Once these test are done, you'll want to remove the line you added.

(An aside: in the course of my experimentation, I also have also installed the
`ruff-lsp` language server, and a quick web search on that suggests that it
does both formatting and linting. Maybe there is no need for `black` and
`pyright`?)

# Further reading and viewing

Elija Manor has a great video, at
[https://www.youtube.com/watch?v=N93cTbtLCIM](https://www.youtube.com/watch?v=N93cTbtLCIM),
that shows the power of lazyvim.  I recommend this very highly. Quite a lot of
material is covered quite quickly, but it's a video, so you can pause to take
notes. Also, the presenter zooms in on the material so it's easy on the eyes,
occasionally zooming out so you can see other parts of the computer display.  I
don't know when I've ever seen a tutorial video that does this, but I *sure*
wish everyone would copy Manor.

In case it's helpful, I put my `~/.config/nvim` contents in a github repository
at [https://github.com/dankelley/nvim](https://github.com/dankelley/nvim).  (I
think it's better for folks to follow the above, though, to learn more about
the changes that were made to the standard lazyvim setup.)
