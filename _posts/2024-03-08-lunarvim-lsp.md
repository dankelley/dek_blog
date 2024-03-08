---
author: Dan Kelley
date: 2024-03-08
title: Demonstration of Language Server Protocol in Lunarvim
---

I just made a [youtube video](https://youtu.be/m3mk6w3Xu2Y) in which I show how
to navigate through code using the neovim package called lunarvim. My test case
is an R file.  In a nutshell, I show two commands, each enabled by a few
keystrokes.

1. Typing the SPACE key followed by the `l` key and then the `s` key shows a
   list of "symbols" in the document being edited.  In the video, I type things
   slowly, so that you can see that lunarvim will provide suggested keystrokes,
   e.g. `l` is just one of several options that are displayed when I type SPACE
   and wait for a moment. Of course, there is no need to wait for these
   prompts, if you can remember the keystroke sequence you want for a given
   task. Here, I am seek the definition of a function called `threenum`. I show
   how typing just a few letters of that name suffices to get me to the
   definition.
2. Once my cursor is on a symbol (in this case, a function, but it could also
   be a variable, a class name, etc.), typing `gr` will show a list of
   references to that symbol. Importantly, that searches not just the present
   file, but other files in the directory.

I try to make the point in this video that this LSP methodology is
*much* more powerful than just searching by text.  The point is that
the editor uses the LSP to analyse the files.  So, for example, if I
am editing in a function and ask for the definition of a variable, it
finds that definition *within* that function, ignoring definitions in
other functions of something that shares the same name.  And it
does not give false positives for mentions that are commented-out,
etc.  Basically, LSP makes your editor code-aware.
