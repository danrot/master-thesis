# State of the art

This chapter will describe a few versioning implementations in different kind
of software systems. The most important implementation is Jackrabbit, since
there already is a transport layer for Jackalope and it is an implementation of
the JCR specification, which the solution provided by this theses must also
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
structure as described there. Figure 2, taken from the JCR specification, shows
how content is structured in Jackrabbit and any other JCR and PHPCR
implementations.

![The content structure of JCR](diagrams/jcr_content_structure.png)

As you can see the repository is the top element of the content structure. It
can consist of multiple workspaces, and each of the workspaces contain an
arbitrary number of nodes. These nodes have relation to other nodes, so that
they can build a directed acyclic graph. Currently the shareable node feature,
which enables a node to have two parents, is not implemented in Jackalop. This
means that it is only possible to build trees in the PHPCR implementation.

Each node can have several properties, which contain some value. This value can
be a simple scalar, as a number, string or a boolean. These properties are
typed, which is a bit untypical for PHP. As you can see in figure 2 it would
also be possible to store images in PHPCR, which means that an export of this
content repository would also contain the required assets for the content.

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

The following listing shows the structure of a root node with a simple title:

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

## PLM

## Version Control Systems

### General

### Git
