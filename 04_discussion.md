# Discussion

In this chapter some of the solutions elaborated in this thesis will be
discussed. There might be better solutions for some of the solved problems,
which have not been implemented for various reasons. The most common reason is
keeping backwards compatibility, so some of the discussed better solutions
could be implemented in a future version of Jackalope, which then will break
the backwards compatibility.

Some of the changes would have been possible before the next major release, but
they were not in the scope of this thesis, nor in the scope of the work that
should have been done in the pull requests I created on GitHub. The maintainers
prefer smaller pull requests, so that the changes could be tested and reviewed
more easily, and therefore keep the quality of the product high.

## Node type checks

Probably one of the most repetitive tasks while implementing versioning was to
check if a node has a certain mixin, namely one of `mix:simpleVersionable` or
`mix:versionable` (which inherits from the first one), attached. These mixins
define some required properties for the versioning mechanisms and are required
to be present on the node if versioning operations are executed on it. If this
is not the case an `UnsupportedRepositoryOperationException` is thrown.

In order to do this the `isNodeType` method exists on the `Node` class. In
addition the `VersionHandler` has two constants defined:

```php
class VersionHandler
{
    const MIX_VERSIONABLE = 'mix:versionable';
    const MIX_SIMPLE_VERSIONABLE = 'mix:simpleVersionable';

    // ...
}
```

The problem here is that the information is now duplicated in some way, because
the mixins are already described in the `NodeTypeInterface`, but in a different
notation.

```php
interface NodeTypeInterface
    extends \PHPCR\NodeType\NodeTypeDefinitionInterface
{
    // ...
    const MIX_SIMPLE_VERSIONABLE =
        "{http://www.jcp.org/mix/1.0}simpleVersionable";

    const MIX_VERSIONABLE =
        "{http://www.jcp.org/mix/1.0}versionable";
    // ...
}
```

The URL written in curly braces acts as the namespace, so that different node
types or mixins do not collide with each other. However, this URLs are not very
comfortable to write. For that reason shorter names like `mix` instead of the
URLs are introduced. This causes, in combination with the fact that the
`isNodeType` method only supports the shorter name, the duplication of this
information in both interfaces.

The best solution would be to use the information available in the
`NamespaceRegistry`. This class knows about the mapping between these URLs and
the short names of the namespaces. But the method should also work with the
notation there was until now, so it should work with both variants of the
namespace representation.

Currently the method call to check if a node has a given node type looks
something like this in the `VersionHandler`:

```php
$node->isNodeType(static::MIX_SIMPLE_VERSIONABLE);
```

As you can see the `static` keyword is used, so this call uses the information,
which have been duplicated in the `VersionHandler`.

If this would be the case, it would be really easy to remove this additional
constants from the `VersionHandler` and 

If the `isNodeType` method would also work with the extended version of the
mixin names used in the `NodeTypeInterface` the newly introduced duplicated
constants in the `VersionHandler` could easily be removed, and the already
existing constants could easily be used instead.

```php
$node->isNodeType(NodeTypeInterface::MIX_SIMPLE_VERSIONABLE);
```

Of course this would also have the advantage that in case of a change in the
mixin names the code would have to be adjusted in only one location.

## Mixing of layers

## Setting protected properties

## Handling of different node types in different transport layers

