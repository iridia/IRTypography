# IRTypography

Tiny methods that should help when dealing with Core Text.  Written when using Omni Frameworks for the iPad.  Contains code that does these:

* gives you a bounding UIBezierPath for a range in a large attributed string containing a particular attribute
* lets you define transformers and hop between persisted and presentable states of attributed strings
* makes working with text attachments, especially invoking bound actions to a range in the attributed string, a lot more easier
* allows blocks-based CTLineRef and CTRunRef enumeration within a particular frame

This pile of code was written some six months ago against iOS 4.3.  It might be naïve, or even relatively untested for cases that are not in the particular application against whose codebase the mini-framework is created.  Some of them could even go away, if substitutes are found in colossal Omni frameworks.

This framework relies upon `IRFoundations` and the Omni frameworks.  To create an app, simply link them all.  To create some static library, use weak linking.
