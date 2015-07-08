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

The design considerations already explained in Chapter 3.2 were the cleanest
way to integrate optional versioning into Jackalope while maintaing backwards
compatibility. Maintaining backwards compatibility was absolutely necessary,
but the resulted design has some drawbacks.

First the code for the login has to be adapted, so that an instance of the
`VersionHandler` is set on the `Client`. This is done in the `login` method of
the `Repository` class, which finally returns a `Session` object.

```php
public function login(
    CredentialsInterface $credentials = null,
    $workspaceName = null
) {
    /** @var $session Session */
    $session = $this->factory->get(
        'Session', 
        array(
            $this,
            $workspaceName,
            $credentials,
            $this->transport
        )
    );
    $session->setSessionOption(
        Session::OPTION_AUTO_LASTMODIFIED,
        $this->options[Session::OPTION_AUTO_LASTMODIFIED]
    );
    if ($this->options['transactions']) {
        $utx = $this->factory->get(
            'Transaction\\UserTransaction',
            array(
                $this->transport,
                $session,
                $session->getObjectManager()
            )
        );
        $session->getWorkspace()->setTransactionManager($utx);
    }

    if ($this->transport instanceof GenericVersioningInterface) {
        $this->transport
            ->setVersionHandler(new VersionHandler($session));
    }

    return $session;
}
```

The `factory` variable contains a `get` method, which just retrieves a name and
some parameters. The name will be looked up in some namespaces, and a new 
reflection class is created. The reflection class is cached, but everytime the
`get` method is called a new object is created, whereby the given array is
passed to the constructor. This design was chosen, because it is quite easy to
offer another factory, which returns different classes for testing purposes.

However, this is not a replacement for a dependency injection container. This
is one of the reasons it was so hard to get a reference of the `VersionHandler`
into the `Client` class resp. the `transport` variable. In a dependency
injection environment like Symfony it would have been quite easy to inject this
optional parameter via a setter injection, since it is available all the time,
and it does not matter where exactly the object was created or where a
reference to it is kept. Actually the reason for this is that the dependency
injection container creates all objects and keeps a reference to all of them.
But it is of course not possible to use Symfony in Jackalope, since the library
tries not to force the usage of any specific framework, which is considered
best practice. The framework modules or bundles, as they are called in Symfony,
should then only integrate the library into the framework. [see @noback2014]

So developing this library directly as a Symfony bundle would solve this single
issue, but couples the library to a specific framework and therefore forces
people to use a certain framework, although they might prefer a different one.
So this is not the solution, but there is another one. Fabien Potencier, the
creator of the Symfony framework, has also created a very simple dependency
injection called Pimple.[^21] With this little dependency tasks like setting
the `VersionHandler` as shown in the listing above would get a lot easier and
more elegant.

![The dependencies between verisoning components](diagrams/uml/version_dependencies.png)

Another issue is that there are circular references, which are problematic in
different ways. These dependencies are shown in Figure 15, where you can see
that the classes `ObjectManager`, `VersionHandler` and `Client` share a
circular reference.

Circular dependencies are usually an indicator for bad design, especially if an
application uses some kind of layer architecture. Unidirectional relations and
depencies are a lot easier to handle, because the effect of any change is
easier to estimate.

A possible solution would be to put more logic into the `VersionManager`, and
let the every transport layer already let the `VersionManager` on its own. With
this solution there could still be something like a `GenericVersionManager`,
which is valid for every implementation. If an implementation wants to
implement this functionality in a more specific and maybe performant way, it
should still be easily possible to replace this implementation. Therefore the
entire Jackalope library should be built more like a plugin architecture, which
could probably not be implemented without a big break in backwards
compatibility.

## Setting protected properties

## Handling of different node types in different transport layers

[^21]: <http://pimple.sensiolabs.org/>
