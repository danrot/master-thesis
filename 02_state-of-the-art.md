# State of the art

This chapter will describe a few versioning implementations in different kind
of software systems. The most important implementation is Jackrabbit, since
there already is a transport layer for Jackalope and it is an implementation of
the JCR specification, which the solution provided by this thesis must also
fulfill.

The second approach to check is the one used by some Product Lifecycle
Management systems. The most important question for this approach is if it also
suits content management, which is the use case JCR and PHPCR was built for.

The last approach is the one used by Git and other version control systems. The
main focus will be on Git, since it gained a lot in popularity in the recent
years. The main question is the same as for PLM systems: Is this approach
suitable for the content management use case?

## Jackrabbit

### General structure

Jackrabbit follows the JCR specification, and therefore implements the basic
structure as described there. Figure 2.1, taken from the JCR specification,
shows how content is structured in Jackrabbit and any other JCR and PHPCR
implementations. [see @jcr2015a]

![The content structure of JCR](diagrams/jcr_content_structure.png)

The repository is the top element of the content structure. It can consist of
multiple workspaces, and each of the workspaces contain an arbitrary number of
nodes. These nodes have relation to other nodes, so that they can build a
directed acyclic graph. Currently the shareable node feature, which enables a
node to have multiple parents, is not implemented in Jackalope. This means that
it is only possible to build trees in Jackalope.

Each node can have several properties, which contain some value. This value can
be a simple scalar, as a number, string or a boolean. These properties have
a type, which is a bit untypical for PHP. It would also be possible to store
images in PHPCR, which means that an export of this content repository would
also contain the required assets for the content.

Each of these properties, but also the nodes, might be attached to a namespace,
which is registered via a URI. The namespace itself is then a prefix splitted
by a colon from the rest of the property's or node's name. By default there is
the `jcr` prefix, which is used for system internal properties and nodes. There
will be examples for this in the versioning section.

The nodes can also have a specific type, which has the capability to define 
some required properties and enable to filter for specific types in the
JCR query language SQL-2. Apart from the primary type of a node the node types
can also be applied as mixins, whereby this may also happen during a node's
lifecycle.

The following code snippet will create a title attribute on the root node
(assuming that the `$session` variable is already correctly initialized):

```php
$node = $session->getRootNode();
$node->setProperty('title', 'Headline');
$session->save();
```

And the following listing shows the structure of the root node manipulated by
the above code:

```
ROOT:
  - title = Headline
  - jcr:mixinTypes = Array(
      [0] => rep:AccessControllable
    )
  - jcr:primaryType = rep:root
```

The `title` field is the only custom field in this example, containing a simple
string. The other two fields hold some system internals, as it can be seen by
the `jcr` namespace. `jcr:mixinTypes` defines the mixins, which are applied to
this node, and the `jcr:primaryType` contains the single node type.

### Versioning

Enabling versioning for a specific node is done by adding the `mix:versionable`
mixin to it:

```php
$node->addMixin('mix:versionable');
```

Afterwards the session can deliver an instance of the VersionManager, which
allows to checkout a node for editing and checking in for creating a new
version of the node with the current data:

```php
$versionManager = $session->getWorkspace()->getVersionManager();
$versionManager->checkout($node->getPath());
$node->setProperty('title', 'New headline');
$session->save();
$versionManager->checkin($node->getPath());
```

After executing these lines there will be two different versions stored in the
system and the root node will look a bit different. It will have a few system
properties more, which contain more information for the versioning mechanism.

```
ROOT:
  - jcr:versionHistory = 
   - : b22346b7-ba4c-41e8-82d8-585ccd5b5d2c
  - title = New headline
  - jcr:predecessors = 
  - jcr:baseVersion = 
   - : 2d073818-92ec-406d-95b5-657981a205ce
  - jcr:uuid = cafebabe-cafe-babe-cafe-babecafebabe
  - jcr:mixinTypes = Array(
      [0] => rep:AccessControllable
      [1] => mix:versionable
    )
  - jcr:primaryType = rep:root
  - jcr:isCheckedOut = 
```

Most of the new properties prefixed by `jcr:` are responsible for holding
versioning information, which will be explained furthermore in the next lines.

The `jcr:versionHistory` property references to another node, containing all
the versioning information about this node, since this node is only holding the
current values. `jcr:predecessors` holds a list of references to all the
previous versions of the node. The latest version of this node is referenced
by `jcr:baseVersion`. Finally the `jcr:isCheckedOut` flag shows us, if the
node is currently checked out, and therefore if it is editable at the moment.

The type properties `jcr:primaryType` and `jcr:mixinTypes` stay almost the
same, the only exception is that the mixin `mix:versionable` is applied to the
node.

The following listing shows the structure of the version history node linked in
the `jcr:versionHistory` property, whereby the less important properties have
been omitted:

```
cafebabe-cafe-babe-cafe-babecafebabe:
  - jcr:uuid = b22346b7-ba4c-41e8-82d8-585ccd5b5d2c
  - jcr:primaryType = nt:versionHistory
  jcr:rootVersion:
    - jcr:predecessors = 
    - jcr:uuid = d9b552fd-bde3-421a-913e-f3c7ccb99664
    - jcr:successors = 
     - : 74b8cbca-074d-45da-b24f-e83cd46bcf77
    - jcr:primaryType = nt:version
    jcr:frozenNode:
      - jcr:frozenUuid = cafebabe-cafe-babe-cafe-babecafebabe
      - jcr:uuid = cb93fc6a-c417-4cca-9998-b500a1c58dfa
      - jcr:primaryType = nt:frozenNode
  1.0:
    - jcr:predecessors = 
     - : d9b552fd-bde3-421a-913e-f3c7ccb99664
    - jcr:uuid = 74b8cbca-074d-45da-b24f-e83cd46bcf77
    - jcr:successors = 
     - : 2d073818-92ec-406d-95b5-657981a205ce
    - jcr:primaryType = nt:version
    jcr:frozenNode:
      - title = Headline
      - jcr:frozenUuid = cafebabe-cafe-babe-cafe-babecafebabe
      - jcr:uuid = e874032d-208a-44f5-a431-9fc24215fbbc
      - jcr:primaryType = nt:frozenNode
  1.1:
    - jcr:predecessors = 
     - : 74b8cbca-074d-45da-b24f-e83cd46bcf77
    - jcr:uuid = 2d073818-92ec-406d-95b5-657981a205ce
    - jcr:successors = 
    - jcr:primaryType = nt:version
    jcr:frozenNode:
      - title = New headline
      - jcr:frozenUuid = cafebabe-cafe-babe-cafe-babecafebabe
      - jcr:uuid = ce0a48f5-1ffd-474d-bc09-81fffa25d829
      - jcr:primaryType = nt:frozenNode
```

This node is located in the `jcr:system` node, which is a direct descendant of
the root node. Its main purpose is to hold all the values from the different
versions. The different versions in this example are the `jcr:rootVersion`,
which contains the first version of the node, as well as the two later versions
`1.0` and `1.1`. The naming of the versions is automatically decided by
jackrabbit.

All of these three nodes have a common structure. In this example they are
connected via a doubled linked list, built with the `jcr:predecessors` and
`jcr:succesors` properties. Since both of these properties are an array it is
also possible to build multiple branches, resulting in a directed acyclic graph
instead of a tree. They also have the primary type `nt:version` in common, as
well as a subnode called `jcr:frozenNode`. The structure of this frozen node
can now differ a lot, except for some of the already described system
properties, which are prefixed with `jcr:frozen`. This simply means that they
are holding a frozen state, from a moment in the past. Additionally these nodes
contain all the custom properties defined by the user, as in this example the
`title` attribute.

An advantage of this approach is, that it is built inside of the content
structure from JCR. So it is possible to implement this without touching the
current schema of Jackalope Doctrine DBAL and even without implementing
something that is specific to Doctrine DBAL at all. This means it would be
possible to implement this feature in a transport agnostic way resulting in the
availability of versioning in not only Doctrine DBAL, but in all current and
future transport layers.

## PLM

Product Lifecycle Management systems also contain a lot of versioning
information, but usually concentrate on mechanical engineering, since these
systems try to manage the lifecycle of products also consisting of a physical
part. This chapter will explain the versioning mechanisms of PLM systems.

### Bill of Material

A very important part of a PLM system is the bill of materials, a listing of
all required parts or structural elements for a given product. Figure 2.2 shows
such a structure.

![Bill of Material[see @wenzel2014 p16]](diagrams/bill_of_material.png)

The `ItemStructureElement` is an abstract class, of which two derivations
exist. One is the `CompositeStructureElement`, which can consist of multiple
other elements, and the other one is the `StructureElementConstituent`, which
can be considered as an atomic part. [see @wenzel2014 p16] So this structure is
very similar to the Gang of Four Composite Pattern [see @gamma1995 p163].
However, it differs from this pattern, so that it also allows more complex
structures.

Compared to content management can be said that the `CompositeStructureElement`
is the structure for a page. This page can consist of multiple paragraphs,
images, etc., which are examples for atomic `StructureElementConstituents`.

The `StructureElementType` is a concrete instance of a
`CompositeStructureElement`, which would e.g. be a concrete page with some
values of some specific type. The same counterpart exists for the
`StructureElementConstituents`, which is called a `StructureElementInstance` in
PLM systems.

A special case is the `UntypedStructureElement`, which inherits behaviour from
both, the `CompositeStructureElement` and the `StructureElementConstituent`. It
can be used for unique things like a building, which will never be built
exactly the same twice.

### Naming

Another very important part of any PLM system is the naming. There are a lot of
things that have to be named, e.g. documents, items, organizations or versions,
which makes this topic also important for this thesis.

Figure 2.3 shows a possible way to model such a naming system.
[see @wenzel2014 p33]

![Naming in PLM systems [see @wenzel2014 p33]](diagrams/naming_in_plm_systems.png)

The `Nameable` class stands for any object in the system which is capable of
having none, one or multiple names. These names are represented by the
`ObjectName` class, which can have other nameable objects as context. This way
somebody could also build version numbers like 1.1.3, which can be considered
as version 3 in the context of version 1.1, which again can be considered as
version 1 of version 1.

If a name has to be unique, the `ObjectIdentifier` class should be used. The
nameable object can contain another relation to an `ObjectIdentifier`, which is
just a special `ObjectName` with the constraint of being unique. This relation
has to be referencing to one of the ObjectNames already belonging to the
nameable object.

### Versioning

Finally there is the most important aspect of PLM systems for this thesis: The
versioning and releasing of items in the system.

PLM systems define two different versions of an object as two different designs
of this object. If versions are just identified by increasing version numbers,
some information will be lost:

- Is one design derived from another?
- Is one design being replaced by another one in production or future design
  work?
- Is the design created by the same person?
- Have both designs been generated in the context of the same organization?

![Versioning in PLM systems [see @wenzel2014 p36]](diagrams/plm_versioning.png)

Figure 2.4 shows how these issues could be handled by a PLM system (depending
on the importance of this information). Each `ItemContext` has a relation to a
person, who has been the developer of this item, to an organization in which
the item has been developed, and additionally some relations to other items
determining if this item acts or has been replace or derived from another item.

An already more specified case of an `ItemContext` is an `ItemSpecification`,
which would translate to an interface in programming or the description of a
product in a catalogue (e.g. the size of a screw). Based on the
`ItemSpecification` can be evaluated if the product which fulfills this
specification also fits certain requirements. The `ItemDefinition` is another
specialization of the `ItemSpecification`. It also contains the way how
something is build. So it represents the concrete product. In terms of software
engineering this would be the concrete implementation of an interface.

In addition to that each version gets a consecutive version number, which can
also contain multiple levels. Together with the model shown in figure 2.4 there
is all the needed information available.[see @wenzel2014 p35]

## Version Control Systems

In this chapter the mechanisms of version control systems in general and
especially of Git are discussed.

### General

Version or revision control in general tries to manage the changes of data.
There are different use cases where version control can be applied, whereby
versioning content of a CMS is the most important one for this thesis. But it
is also very important for documents and books or computer programs, which are
probably the most complicated use case, since in a modern version control
system many developers should be able to edit the same file at the same time.
[see @raymond2015a]

A term that all of these systems share is the unique revision number, but how
this number is built differs from system to system. Possible ways to generate
such a number are using an incremental system or generating a unique hash based
on the content of the revision or a UUID. Usually the revision also contains a
timestamp and the creator, identified by an email address or some other unique
identifier.

![Linear version history](diagrams/version_history_linear.png)

Version control systems exist in different variations. Figure 2.5 shows the
easiest way possible, which is to just track a linear version history. This is
sufficient for documents on which only a single person at a time is working
and is widely used on some homepages and word processors. Aside from tracking
the changes on a specific document, this system also allows the user to revert
the document to a previous version, which is a very basic functionality for
such a system. [see @azad2015]

![Non-linear version history](diagrams/version_history_non_linear.png)

More advanced version control systems offer the possibility to manage
non-linear histories as shown in figure 2.6. Usually these operations are
called branching for creating a new path in the version history and merging for
the reunion of multiple branches. This functionality is very important if
multiple persons are working on the same data set, since it enables many
different states of the same document or project. [see @azad2015]

There are two big groups of version control systems. On the one side there are
centralized systems holding the metadata on a central server, and on the other
side there are decentralized systems. The latter differ from the first in the
way developers interact with each other. So has every user in a decentralized
system his own copy of the metadata of the repository containing all the
versioning data. This enables the developers to work asynchronously and without
a connection to the central repository. Therfore the content from others have
to be reintegrated all the time using the merging features of the version
control system.[see @raymond2015a] 

### Git

For a more concrete insight in version control systems, this chapter delivers a
deeper insight into Git. This system was chosen, because it grew extremely in
popularity - especially in the open source community - over the last few years.
[see @dzone2014a] But it also seems to gain more and more attention in the
field of professional software developement. [^13][^14]

On its very core, Git is a content-addressable file system, which the official
Git book describes as a simple key-value store. [see @git2015a]
Content-addressable means that the key for a specific value can be determined
from its content. One of Git's most fundamental function is a cryptographic
hash function, which uses SHA1 to generate a key for the key-value store. This
key is used for all kinds of objects managed by Git. Another advantage of this
approach is that an object can automatically be identified as broken if its
SHA1 hash does not match its key.[see @otte2009a, p9]

Git addresses 4 different types of objects. The one holding the actual content
of the files under version control are the BLOBs (stands for binary large
object). Consider that this type is holding only the content of the file, but
not additional information like the name of the file. This meta information is
kept in the tree objects, which are containing pointers to other Git objects,
together with some names. A tree can also contain another tree. [see @git2015a]

![Git's tree structure](diagrams/Git_tree.png)

Figure 2.7 shows this structure, which is quite similar to a filesystem. The
tree object represents a folder and the blob objects represent the content of
the files. Another important advantage is that the tree objects can be reused
multiple times. This way disk space can be saved, since trees without any
changes don't need to be created another time.

The internal representation of such a tree object looks like the following:

```
100644 blob a0054e492840f572e48a3cb791d2e083afaf08f6    file1
100644 blob 4d4bc1c77f63bd5429cb0ab4d74cb8729570d293    file2
040000 tree 8e98f995b37c9c648a5f55fb0a41de9f4e20c26e    folder1
```

The first number contains access information similar to the ones known from
UNIX filesystems, the second column contains the type of the referenced object,
then comes the key of the referenced Git object, and the last column defines
the name of the reference.

Such a tree is the target of a commit. The commit specifies a certain state of
revision. Therefore it adds more information to a tree. A commit consists of a
pointer to a specific tree, which can be considered as frozen, and adds
information about the author. Actually Git distinguishes between the author and
the commiter. The author is the original editor of the content, whereby the
commiter is the one who added the content to version control. In many use cases
these two roles are taken by the same person. In the PLM context the commit
translates to a `ItemContext`, depending on its content it can possibly be also
further specified as an `ItemSpecification` (e.g. the commit contains interface
definitions) or a `ItemDefinition` (contains concrete implementation).

Tags enable Git users to give certain commits a better name than a SHA-1 hash.
This is widely used for marking releases in the version history. It is quite
similar to a commit, it contains a tagger, a date, a message, and a pointer,
whereby the pointer refers to a commit instead of a tree.

The structure can be compared to the one from jackrabbit, especially the part
with the frozen nodes, since Git also does not save the changes since the last
commit, but keeps a frozen version of the state, except for older commits. The
amount of time that needs to pass before a commit is considered old can be 
configured. [^15] For these Git is doing a garbage collection, which will be
packed into packages with an index, to find also old content in a acceptable
amount of time, without taking too much space.

[^13]: <http://www.itjobswatch.co.uk/jobs/uk/Git%20%28software%29.do>
[^14]: <http://www.itjobswatch.co.uk/jobs/uk/subversion.do>
[^15]: <https://www.kernel.org/pub/software/scm/Git/docs/git-gc.html>
