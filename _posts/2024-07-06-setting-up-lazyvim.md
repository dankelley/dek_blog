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

I started testing by writing this blog item.  I typed in the steps as I did
them, and would have changed the title if lazyvim had proved bothersome to
install.  So, that's a good sign.  But I also need vim to read and work with R
code, so that was my next text.

So, I edited a few R files.  Nothing seemed amiss.  I did find that some of the
keystrokes I had in my head needed replacement. For example, formatting a file
used to be `SPC l f` in my lunarvim setup, but it is `c f` in lazyvim.
(Actually, I won't need to know that, because the default lazyvim setup will
reformat on file saves, and I save file a *lot*.)

It's important to me that formatting be identical to what I had before, but
that is what I found, in editing some files in the oce project.  So, this test
was passed without problems.

There is one significant difference from my lazyvim setup, with respect to the
local leader.  I had this set to `,`  with lunarvim, but it is (by default) set
to `\` in lazyvim.  I will keep this for a while, and in fact I may find that I
prefer it.  But, just to note, the command `,rf` (to launch an R session whilst
editing R source code) is now `\rf`, and `,aa` is now `\aa` etc.  Of course, I
can change the localleader, but I think I'll keep it for a while, since I
prefer to use defaults unless they bother me.

# Final thoughts

It wasn't hard to install lazyvim, and I like using it, so far.

Thanks, Clark, for suggesting that lunvarvim may be a problem, as its
development seems to have slowed considerably.
