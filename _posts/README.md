How to add new content.

1. Write a `.md` file, with name `YYYY-MM-DD-topic.md`, where YYYY is the year,
   etc.
2. If this `.md` file contains code that is to produce results that will go in
   the blog, isolate this code and run it.  If the output is textual, include
   it in the `.md` file.  If it is a figure, put it in `../docs/assets/images`
   with a name that is based on the name of the `.md` file, and then insert
   appropriate links in the `.md` file.  (See the box-model item, as an
   example.)
3. Go one level up, and then use `git add`, then `git commit` and finally `git
   push` to update the content on the server.
4. Wait 5 minutes or so, and then check the webpage to see if the update
   worked, and if you like the look of the content.

