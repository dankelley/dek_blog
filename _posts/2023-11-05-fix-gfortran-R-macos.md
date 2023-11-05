---
title: Fixing the gfortran permission problem for R on macOS
author: Dan Kelley
date: 2023-11-05
---


# Introduction

I just installed the latest version of R (version 4.3.2 (2023-10-31) -- "Eye
Holes") and tried to build the ``oce`` package.  It failed, complaining about an
unknown developer for ``gfortran``.  I tried reinstalling ``gfortran`` from the
site recommended by R, but that didn't help.  I tried updating my ``brew`
version of ``gfortran``, again with no joy.  Then I started searching the web.

Eventually I got to a [stackoverflow comment](https:
//stackoverflow.com/questions/70638118/configuring-compilers-on-apple-silicon-big-sur-monterey-ventura-for-rcpp-and)
that provided a solution that worked for me.  It may also work for you, if you're
having problems *but* be very careful to check that you know what you are doing.  Also,
if you are reading this much past the date of posting, the site that holds ``gfortran``
might have changed, so I recommend you navigate there first, to check.

With those provisos, here is what I did (the last step is not from that website; it's just a cleanup action):

```
curl -LO https://github.com/R-macos/gcc-12-branch/releases/download/12.2-darwin-r0/gfortran-12.2-darwin20-r0-universal.tar.xz\n
sudo tar xvf gfortran-12.2-darwin20-r0-universal.tar.xz -C /
sudo ln -sfn $(xcrun --show-sdk-path) /opt/gfortran/SDK
rm gfortran-12.2-darwin20-r0-universal.tar.xz
```

After taking these steps, I was able to build ``oce`` again.

PS. I think I've gone through quite a lot of R versions without having to fiddle
with gfortran.  So maybe something has changed on the R end.  Then again, I am
running a beta (pre-release) version of macOS, so that might be a problem also.
