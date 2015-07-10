---
title:  Versioning for content management systems using the example of
    Jackalope Doctrine DBAL
author: Daniel Rotter, BSc
matriculation: 1310249002
submissiontown: Altach
submissiondate: July 2015
abstract:
    - Versioning is a very important part of any system trying to manage
      content or documents. So this thesis is about introducing versioning into
      Jackalope Doctrine DBAL, which is an implementation of a so called
      content repository. Such a content repository is defined by the PHPCR
      specification, where it is described as a way to handle hierarchical
      semi-structured data in a semantic way. The main use case of such a
      content repository is a content management system.
    - Versioning is already specified in PHPCR, but currently not implemented
      in the implementation for relational databases, which use Doctrine DBAL
      as an abstraction layer. The goal of this thesis is to implement this
      support according to the specification. Ideally these changes will be
      merged into the official library, in order to be available and further
      maintainable for everyone.
    - This thesis will also try to analyze the problems occuring while
      implementing this functionality. This is quite likely, because the
      project started as a pure client to Jackrabbit, another content
      repository written in Java. Of course the thesis will also try to suggest
      better alternatives to the existing problems.
    - For this reason also the versioning mechanisms of other systems with a
      high priority on versioning are compared, this includes Jackrabbit,
      product lifecycle management systems and version control systems. Whereby
      the latter one is divided into a general part and a part about git, a
      version control system originally developed for Linux and growing in
      popularity.
zusammenfassung:
    - zusammenfassung
---
