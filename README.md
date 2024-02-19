This repository holds the source code for a new (late 2023) attempt at a blog
(at https://dankelley.github.io/dek_blog/), which I hope to serve as a
replacement from an old blog (http://dankelley.github.io/blog/) that has become
difficult to maintain, owing to difficulties with installing Ruby gems on a
macOS machine.

# How transferral is done

Do this by e.g.
```
cd ~/git/dek_blog/_posts
cp ~/git/dankelley.github.io/_posts/2014-11-10-solar-navigation.md .
```

But, wait, there's more!  Must next:
1. edit the `.md` file to remove specialized yaml, like keywords/tags,
   category, summary, etc.
2. put the date in new format
3. insert links to images
4. copy images to `assets/images`

# Items that have been transferred from the old blog

* 2022-02-16-vim-julia
* 2020-09-30-dislike-ggplot
* 2016-02-09-noreaster
* 2015-10-18-shiny-ctd-trim
* 2015-08-25-email-graphs
* 2014-07-01-landsat
* 2013-12-28-sundial
* 2013-12-21-solstice
* 2014-11-10-solar-navigation
* 2014-03-16-box-model
* 2014-02-13-valentine-moon
* 2014-01-15-colourizing-along-a-trajectory
* 2014-01-11-inferring-halocline-depth
* 2013-12-30-installing-oce
* 2013-12-21-day-length

# Diary of Work Progress

1. It took me ages to determine where and how to alter the css.  The answer is
   to put the code into `assets/main.scss`; see that file for more.

