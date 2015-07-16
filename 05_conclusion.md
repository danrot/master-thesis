# Conclusion and outlook

In general it is really nice to be part of a successful open source project,
which is widely used on many websites spread all over the world. It is also a 
great possibility to get a good reputation in the developer community, and to
establish interesting contacts with authorities in this community, which can be
useful in a future career.

The work is not completely finished, mainly due to the lack of some missing
functionality I supposed to already be there, like the retrieval of a node type
definition from a node. Actually this caused the only big feature missing at
the moment, which is the consideration of the `onParentVersion` attribute for
child nodes when creating a new version or restoring an already existing one.

A versioning feature that has been omitted by intent is the removing of a
version. This is allowed with regard to the specification, which says that an
implementation might offer the ability to remove versions. However, this is
probably not the most important function for a versioning system, since it is
about storing the history for a certain objects. For this reason this feature
has not been implemented.

There were also very interesting considerations due to the fact that Jackalope
originally started as a PHP client for Jackrabbit. When the community decided
to split it up into a base library and multiple transport layers, so that they
could start a Doctrine DBAL implementation, the project began with limited
functionality and grew over time. This is why some of the PHPCR util libraries,
tests and the Jackalope base library is bound to some details of the Jackrabbit
implementation. These details have been obstacles for the versioning
implementation, and therefore also some code had to be moved, some
architectural decisions reconsidered and so on. 

Of course I will continue to work on this versioning implementation. I really
would  like to see it being merged, because of all the work I have invested in
it. Fortunately also MASSIVE ART will have an interest in the Jackalope project
in the future, since it is one of the most important libraries in Sulu.

One of the next interesting steps is to integrate this versioning functionality
in Sulu. Therefore the Sulu APIs have to be extended to support the versioning
methods of PHPCR, and this functionality has to be embedded into the user
interface somehow.

Another interesting future topic will be Jackalope 2.0, the next major release
of Jackalope. There are already plans to develop this next major release.
This release should focus and modularity, stability and performance[^26], and
plans to cover some of the problems addressed in the previous discussion
chapter. So there are plans to introduce a dependency injection container and
some kind of plugin architecture.

Unsurprisingly the part of the state of the art chapter, which had the highest
amount of influence on this thesis, is the chapter about Jackrabbit, since
Jackalope has to fulfill the same specification.

The PLM approach is too strict in some points. E.g. in content management there
is no distinction between different ItemContexts. The bill of materials also
does not apply to PHPCR, because it is a schemaless data store, where any
property can be added to any node. It is possible to enforce the existence of
some properties, but this does not go as far as the bill of materials. However,
this approach might be more interesting for the definition of templates in
Sulu. But the naming approach applied by PLM systems are definitely interesting
for PHPCR for two reasons. First, the unique path of a node already follows
these scheme, because the name of all nodes build the path, and therefore each
node name is unique on its own level, what would be called a context in a PLM
system. Second, it would be interesting for labeling the versions, which is
currently solved by just using a simple UUID.

There are also features PHPCR shares with Git. Both systems are storing the
state of their content in the same way. They are just taking a snapshot and
store this data somewhere. This has the advantage that recovering this data is
quite fast, but it takes a lot more space. Git handles this a bit better, since
it contains an garbage collection option, which allows it to define at which
age content should be archived into index files. These files are only storing
the difference between different versions, and therefore save a lot of space on
the hard drive. This would also be an interesting option for PHPCR.

[^26]: <https://groups.google.com/forum/#!topic/symfony-cmf-devs/PDS5wDt8IxM>

# Bibliography
