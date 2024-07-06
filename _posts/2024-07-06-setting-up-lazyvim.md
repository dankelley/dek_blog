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

1. I visited http://www.lazyvim.org/installation and followed the
   steps.  I named the backups as `bak-for-lazyvim` instead of just
`*.bak` as suggested. (Note the cool way of renaming files -- I had
not seen that before!)

2. I installed the R language server by starting `nvim` and typing
   `:Mason`, then typing 2 to get the LSP listing, then using the
arrow to go down to the item called `r-languageserver` and selecting
that.  At this point, you can edit R files but we want more!

3. For years, I have relied on the wonderful `R-nvim` package
   (https://github.com/R-nvim/R.nvim) and its predecessors, written
Jakson Alves de Aquino (www.github/jalvesaq) and colleagues, so my
next task was to set that up. Doing this was easy.  I just edited
`.config/nvim/lua/plugins/example.lua`, changing

```lua
return {
-- add gruvbox
```

    to read

```lua
return {
  -- add R-nvim
  {
    "R-nvim/R.nvim",
    lazy = false,
    R_assign = 2,
  },

  -- add gruvbox
```

4. On a test with an R file, I found that it was indenting with 2 spaces,
   instead of the 4 that I use in all my work.  So, I changed
`~/.config/nvim/init.lua` from

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

Oh, one more thing: lazyvim showed keystroke hints only for thing
starting with `SPC`, but lazyvim is showing hints for all keystrokes.
I find that very helpful.

# To do

I still need to figure out how to make `,rf` run R code!  This is a
pretty big one, but I'll look into that after lunch and edit this blog
posting then.  I want to see how it previews, anyway.


