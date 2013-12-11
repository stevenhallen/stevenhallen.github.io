---
title: 'git rebase: Reordering Commits'
date: 2013-03-04 21:41 UTC
tags: git, rebase, post-programming
---

In the [first article](http://google.com) in this series, I talked about the spectrum of utilization that exists for source code control tools. To recap:

###Characteristics of poor utilization

* Each commit generally introduces more than one atomic change;
* The series of commits over time is generally not very well ordered (it doesn’t tell a coherent story).

###Characteristics of rich utilization

* Each commit generally introduces a single change;
* The series of commits over time is well-ordered (it tells a coherent story).

###Rebase is your tool

In order to transform a set of non-atomic commits into a set of atomic commits, we need the ability to edit commits. In order to transform a poorly ordered set of commits into a well-ordered set of commits, we need the ability to reorder commits.

Specifically, we need the following capabilities:

* Reorder an existing set of commits
* Break one commit into multiple commits
* Combine multiple commits into a single commit
* Edit the commit message for a commit
* Remove content from one commit and add it to a different commit
* Remove content from a commit
* Add content to a commit

git rebase lets you do all of this.

Let’s start with the first one. Imagine the following changes:

  # show the last two changes  
  $ git log head~2..  
  commit d5608114efd9b8f50849c4774215955427c1b37c  
  Author: Mark McEahern &lt;mark@mceahern.com&gt;  
  Date: Mon Mar 4 08:24:21 2013 -0600  

First change

  commit 80b16e143e90e87d582ce0472e142ac60be835dd  
  Author: Mark McEahern <mark@mceahern.com>  
  Date: Mon Mar 4 08:24:12 2013 -0600  

Second change

Notice they’re in the wrong order. Second change happened first. Let’s fix that:
  $ git rebase -i head~2

When we issue that command, we end up in our git editor with the following content:
  pick 80b16e1 Second change
  pick d560811 First change

  # Rebase 50a01a7..d560811 onto 50a01a7    
  #  
  # Commands:  
  # p, pick = use commit  
  # r, reword = use commit, but edit the commit message  
  # e, edit = use commit, but stop for amending  
  # s, squash = use commit, but meld into previous commit  
  # f, fixup = like “squash”, but discard this commit’s log message  
  # x, exec = run command (the rest of the line) using shell  
  #  
  # These lines can be re-ordered; they are executed from top to bottom.  
  #  
  # If you remove a line here THAT COMMIT WILL BE LOST.  
  #  
  # However, if you remove everything, the rebase will be aborted.  
  #  
  # Note that empty commits are commented out  

To reorder the commits, we simply edit the list at the top so that it looks like this:

  pick 80b16e1 Second change  
  pick d560811 First change  

Then we save and exit the file. After doing that, we see the following output:
Successfully rebased and updated refs/heads/master.

In addition, our git log now looks correct (since it’s most-recent commit first, we expect to see Second change, then First change):

  $ git log head~2..  
  commit 1133a1e1e38b26b04968e50904034b8509f94975  
  Author: Mark McEahern <mark@mceahern.com>  
  Date: Mon Mar 4 08:24:12 2013 -0600  

Second change  
  commit b066c2e45402146641f2cfc8bae392c4a8fc7403  
  Author: Mark McEahern <mark@mceahern.com>  
  Date: Mon Mar 4 08:24:21 2013 -0600  

First change

That was easy! In this example, I purposefully made these commits against different files, so that there was no possibility of conflict between the two commits. Obviously, that’s not usually the case. As we work through the other operations, we’ll get into the details of resolving conflicts.

In the next article, I’ll show you how to break one commit into multiple commits.
