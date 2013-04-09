[![Build Status](https://travis-ci.org/lxcid/LXSupport.png)](https://travis-ci.org/lxcid/LXSupport)

LXSupport
=========

A project inspired to be the ActiveSupport of Objective-C.

Rationale
=========

The Objective-C world is filled with lots of great Open Source projects. One of the type of projects that I see often are the ActiveSupport-like project. While many are great, I couldn't find one that I am comfortable with. Thus I embark on releasing my own.

The goal of this project is to remove the little nuisance you experience as an Objective-C programmer.

For example:

 - Your designer pass you a hex triplet color code.
 - Serialized of JSON to NSDictionary/NSArray contains NSNull object that crash your code, because you can't safely assume nil, which when performed an selector on just result in nil (No crash).
 - There's lastObject for NSArray, but no firstObject.

Disclaimer
==========

I am not a great Open Source project maintainer, I would have to warn first. But I'll try my best.

Further Disclaimer
==================

Also, as this project is a consolidation of many great solutions found in the net, which can come in form of blog post, snippets from other open source projects, forums, stack overflow. Tracking credits is hard. Usually they are mentioned as code comments, github issues. But I'm not ready to lead this project yet. So they will remains in these places for now.

These are hand copied and sometimes improved solution, comforming to my coding convention, (some) guard against unit tests, refactored.
