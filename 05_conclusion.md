# Conclusion and outlook

In general it is really nice to be part of a successful open source project,
which is widely used on many website spread all over the world. It is also a 
great possibility to get a good reputation in the developer community, and to
establish interesting contacts with authorities in this community, which can be
useful in the future career.

The work is not completely finished, mainly due to the lack of some missing
functionality I supposed to already be there, like the retrieval of a node type
definition from a node. Actually this caused the only big feature missing at
the moment, which is the consideration of the `onParentVersion` attribute for
child nodes when creating a new version or restoring an already existing one.

A versioning feature that has been omitted by intent is the removing of a
version. This is allowed with regard to the specification, which says that an
implementation might offer the ability to remove versions. However, this is
probably not the most important function for a versioning system, since it is
about storing the history for a certain objects. For this reason these feature
have not been implemented.

There were also very interesting considerations due to the fact that Jackalope
originally started as a PHP client for Jackrabbit. When the community decided
to split it up into a base library and multiple transport layers, so that they
could start a Doctrine DBAL implementation, the project started quite small
with basic functionality, and enhanced from time to time. This is why some of
the PHPCR util libraries, tests and the Jackalope base library is bound to some
Jackrabbit details. This details have been obstacles for the versioning
implementation, and therefore also some code had to be moved, some
architectural decisions reconsidered and so on. 

Of course I will continue to work on this versioning implementation, because
after all the work I have pushed into it, I really would like to see it being
merged. Fortunately also MASSIVE ART will have an interest in the jackalope
project in the future, since it is one of the most important libraries in Sulu.

One of the next interesting steps is to integrate this versioning functionality
in Sulu. Therefore the Sulu APIs have to be extended to support the versioning
methods of PHPCR, and this functionality has to be embedded into the user
interface somehow.

Another interesting future topic will be Jackalope 2.0, the next major release
of Jackalope. There are already plans to develop this next major release.
This release should focus and modularity, stability and performance[^26], and
plans to cover some of the problems addressed in the previous discussion
chapter. So there are plans to improve dependency injection and introduce some
kind of plugin architecture.

[^26]: <https://groups.google.com/forum/#!topic/symfony-cmf-devs/PDS5wDt8IxM>

