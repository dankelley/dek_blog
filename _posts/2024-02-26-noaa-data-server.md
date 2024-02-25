---
author: Dan Kelley
date: 2024-02-26
title: Downloading data from NOAA server
---

# Introduction

There are quite a few web sites that offer oceanographic data, and it can be
confusing to know which to try.  Compounding this problem is that fact that
they are all different, so it can take a while to learn that site A is not
suitable, and that site B ought to be investigated. Quite a while later, it's
on to site C. Unless a person takes detailed notes on what data is provided by
each site, along with the scheme to use that particular site.

Site hopping is not just frustrating, it is a waste of time.  And new sites
just keep cropping up, as group after group realizes that the existing sites
each have some problem or other.  The "Standards" XKCD cartoon (Reference 1)
comes to mind.

My criteria for a good site are that it
1. offers a wide range of data (new as well as old),
2. has an easy-to-use graphical interface,
3. offers a way to skip the mouse actions by using URL construction,
4. and is relatively stable over time.

Of course, the data also ought to be freely accessible, but that is a given,
for my work in academia.

Recently, I had some experience with a NOAA site (Reference 2).  It meets several
of my criteria.  I will explain it by snapshots.

# 1. Set the scope of your search

When you visit Reference 1 and scroll to the bottom of the page, you will see
view shown below.  What to do next is quite straightforward, so this site meets
Criterion 2.  And, from the checkbox list, we have evidence that Criterion 1
may also be met.  (I won't detail this much more here, but I found everything I
was looking for here.)

As you can see from the image, I was interested in CTD data acquired by a
certain ship, in a certain year. Then I clicked the "Build a query" button.

![01.png](/dek_blog/docs/assets/images/2024-02-26-noaa-data-server-01.png)

# 2. Build a search query

My goal is to get a dataset acquired by R.V. Endeavor in 1988.  At the top of
the query page, I selected from and to dates, as in the following snapshot.
(Obviously, if you chose to search for other things, this page will not look
the same.)

![02.png](/dek_blog/docs/assets/images/2024-02-26-noaa-data-server-02.png)

Scrolling down on the page, I selected just the CTD option.

![03.png](/dek_blog/docs/assets/images/2024-02-26-noaa-data-server-03.png)

Further down, I specified the ship.  Unless you know the ship number, you ought
to click on the "Go to ship" button to find the code.  When you do that you'll
see a view like below (notice that I selected the Endeavor as it was designated
during the time of the data, before its number was change after a refit).

![04.png](/dek_blog/docs/assets/images/2024-02-26-noaa-data-server-04.png)

Once the ship was selected, I clicked the "Submit ship" button.  This returns
me to the previous screen, which now has the ship code filled in. This is shown
below.  (Notice the red text.)

![05.png](/dek_blog/docs/assets/images/2024-02-26-noaa-data-server-05.png)

# 3. Verify that the dataset is what you want

After perhaps a minute, you will be on a page that either says it
found data, or not.  In my case, it did find data.

The page has buttons named "VIEW DATA DISTRIBUTION PLOT" and "CRUISE LIST".  I
didn't click either, because I want to look at the data using my own tools.  At
the bottom of the page is a button labelled "DOWNLOAD DATA".

![06.png](/dek_blog/docs/assets/images/2024-02-26-noaa-data-server-06.png)

# 4. Specify a download format

At this stage, you get to decide on a data format, and some details
of the data themselves.

The item marked "1 CHOOSE FORMAT" offers three choices. I've tried all three of
them.  The "WOD native ASCII format" yields a file of a few letters and a lot
of numbers jumbled together. I was not familiar with this format, so I tried
building some of the tools that are given by NOAA.  This included code
in C and in Fortran.  I could not get any of these to build on my machine.  For that reason, I do not recommend this option.

I also tried the "Comma Delimited Value (CSV) format" option, but I never got
an email telling me that the files had been prepared.  So, I also do not
recommend this option.

However, the "netCDF format" option worked. I elected for individual files, as
you can see in the snapshot.

Item "2. CHOOSE DEPTH LEVEL" lets you choose between the observed 
data and values interpolated to standard depths.  I want the former.

Item "3 CHOOSE FLAG TYPES" offers two choices.  I selected the WOD option, And
not knowing what the other meant.  (You may want to explore both options.)

Item "4 CHOOSE XBT/MBT corrections" does not apply to CTD data,
so I left it at the "No corrections" value.

And, finally, I gave my email address.  When the data are prepared, I got an
email with a link to click.  That link is to a gzipped tar file that contains
all the netcdf files. I made a video (Reference 3) about how I dealt with those
file in the R language.

![07.png](/dek_blog/docs/assets/images/2024-02-26-noaa-data-server-07.png)




# References

1. XKCD cartoon about expansion of standards:
   [https://xkcd.com/927/](https://xkcd.com/927/)
2. NOAA site discussed here:
   [https://www.ncei.noaa.gov/access/world-ocean-database-select/dbsearch.html](https://www.ncei.noaa.gov/access/world-ocean-database-select/dbsearch.html)
3. Youtube video showing how to handle the downloaded netcdf files in the R
   language: [https://youtu.be/A9csPU7BWn4](https://youtu.be/A9csPU7BWn4 )
