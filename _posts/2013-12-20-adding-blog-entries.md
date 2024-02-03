---
title: How to add content to this blog
author: Dan Kelley
date: 2013-12-20
---

How to add new content.

1. Write a `.md` file in the `_posts` directory, with name
   `YYYY-MM-DD-topic.md`, where `YYYY` is the year, etc. Use hyphens to join
   words in the topic portion.  Start R code blocks with a line containing
   \`\`\`R and end them with a line containing \`\`\`, doing similar things for
   other languages.
2. If this `.md` file contains code that is to produce results that will go in
   the blog, isolate this code and run it.  If the output is textual, include
   it in the `.md` file.  If it is a figure, put it in `../docs/assets/images`
   with a name that is based on the name of the `.md` file, and then insert
   appropriate links in the `.md` file.  (See the box-model item, as an
   example.)
3. Go one level up, and, in the commandline, use `git add`, then `git commit`
   and finally `git push`.  This will update the content on the server.
4. Wait a few minutes, and then check the webpage to see if the update worked,
   and if you like the look of the content.

