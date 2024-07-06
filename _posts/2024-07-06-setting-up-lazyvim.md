---
author: Dan Kelley
date: 2024-07-06
title: Setting up lazyvim
---

**Abstract.** I've been using lunarvim for a while, but learned (from
my friend Clark Richards) that it is no longer actively maintained.
So, I decided to consider other neovim distributions.  This posting
describes how I set up lazyvim, which I decided was my best choice.

# Decision process

First, I had a look at astronvim.  It seems to install easily, and it
edited a couple of sample files without problems. But when I tried to
edit R files (not all, but some), I saw error messages. I tried web
searches on those messages (in a file called `query.lua`) but got
nowhere.

Then I tried web searches for alternatives.  I ran across a youtube
video (https://www.youtube.com/watch?v=bbHtl0Pxzj8) that I found quite
helpful.  It scored lazyvim the highest of four tested distributions,
but the others were nearly as high.  The deciding factor for me was
the author: it is the Folke Lemaitre, (https://github.com/folke) who
is a simply superstar in the neovim circles, having written the
amazing `lazy` package plus much, much more (over 2000 commits in the
first 6 months of the year!).

# Setting up lazyvim

First, please note that I may have left out some steps, so please
refer to https://www.lazyvim.org as the preferred source of
information.

My main goal (for now) is to get it set up to do R coding, using the
formatting scheme used in the oce project
(www.github.com/dankelley/oce), authored by the aforementioned Clark
Richards, myself, and our colleague Chantelle Layton.

# Steps to installing

## Follow the general advice from lazyvim.org

I visited http://www.lazyvim.org/installation and followed the steps.  I named
the backups as `bak-for-lazyvim` instead of just `*.bak` as suggested. (Note
the cool way of renaming files -- I had not seen that before!)

## Install the R language server

I installed the R language server by starting `nvim` and typing `:Mason`, then
typing 2 to get the LSP listing, then using the arrow to go down to the item
called `r-languageserver` and selecting that.

## Set up the R-nvim plugin

For years, I have relied on the wonderful `R-nvim` package
(https://github.com/R-nvim/R.nvim) and its predecessors, written Jakson Alves
de Aquino (www.github/jalvesaq) and colleagues, so my next task was to set that
up, by creating a new file called `.config/nvim/lua/plugins/myplugins.lua` with
contents as follows.  (I suspect I'll be copying some other items from the
`.config/nvim/lua/plugins/example.lua` file into `myplugins.lua`, as time goes
on.)

```lua
return {
  -- add R-nvim
  {
    "R-nvim/R.nvim",
    lazy = false,
    R_assign = 2,
  },
}
```

## Set indentation for R

On a test with an R file, I found that it was indenting with 2 spaces, instead
of the 4 that I use in all my work.  So, I changed `~/.config/nvim/init.lua`
from

```lua
-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
```

to

```lua
-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
vim.o.tabstop = 4
vim.o.expandtab = true
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
```
# Testing the installation

I edited a few R files, and found that everything seems to be working
fine.  I need to unlearn some keystrokes that I have in my mind from
using lunarvim (promimently, formatting a file has changed from `SPC l
f` to `c f`), but that won't be hard.  Some of the UI behaviours are a
bit changed, e.g. the popup windows look different, but so far I
really like the look and feel of lazyvim.

In addition to editing some R files, verifying that a full file
reformat did not alter the file (a requirement for me -- I don't want
for example the oce code to change if an editor is changed).

**Note** that this setup has R commands prefixed by `\`, e.g. to start an R
session whilst editing an R source file, type `\rf`.  I was using `,rf`
previously, because I had set the localleader to `,`, replacing the default of
`\`.  However, I am going to try this other format for a while, and see if I
like it.


# Final thoughts

So far, I like lazyvim.  I may end up changing the default colourscheme to what
I had used in lunarvim, and I might change the local leader to `,` ... but, for
now, I intend to keep both systems on my system, and I these differences help
me to "know" which one I'm in, without thinking about it.  (The say way I
"know" where keys are on the keyboard, without thinking about that.)


