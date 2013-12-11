---
title: 'git rebase: Rewriting History for Fun and Profit'
date: 2013-01-22 21:40 UTC
tags: git, rebase, post-programming
---

In this series of articles, I want to share a little bit about my git workflow. I use git rebase fairly heavily. I think git rebase is essential to using git effectively.

For starters, I rarely get things right the first time. If it ever seems like that to the casual observer, it’s because it’s not really the first time.

Here’s what I typically do when I’m working on something new:

1. Hack
2. Does it work?
3. Repeat
4. Oh my god, it works?

Eventually, I might have some tests for the critical stuff, some database migrations (along with associated schema changes), some model changes, some controller changes, etc.

One approach to pushing these changes to a remote is:

1. Commit everything all at once
2. push, with force if necessary

That’s probably the least effective approach. (But who hasn’t done it?)

===Spectrum of Utilization of git

The spectrum of utilization that I think exists for source code control is something like this:

Poor utilization:

* Each commit generally introduces more than one atomic change;
* The series of commits over time is generally not very well ordered (it doesn’t tell a coherent story).

Rich utilization:

* Each commit generally introduces a single change;
* The series of commits over time is well-ordered (it tells a coherent story).

What I love about git is that it makes it incredibly easy to operate on the rich end of the utilization spectrum without requiring that you Do It Right™ from the beginning.

With git rebase, you can take an arbitrary series of commits and completely rewrite that history, to turn what might otherwise have been an unordered arbitrarily-and-varied sized set of commits into a well-ordered list of atomic commits.

In this series, I will show you why and how you would do that.
