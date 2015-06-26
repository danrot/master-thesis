# Implementation

This chapter will explain how versioning in the Doctrine DBAL transport layer
of jackalope was implemented.

## Structure

The project is split into many different git repositories. The next sections
will explain each of the repositories, on which work has been done, in order to
complete the goal of implementing versioning for the doctrine dbal transport
layer.

### Jackalope

The Jackalope repository [^13] contains all the code not being coupled to any
specific transport layer. So many implementation details of the JCR
specification have already been implemented in this repository in a storage
agnostic way. Because of this storage agnostic implementation the only part
which has to be delegated to one of the transport layers is the actual storage
of the structure in some persistent memory. Since this is handled differently
in every storage (e.g. SQL in relational databases, WebDAV in combination with
Jackrabbit, some kind of serialization if the data is saved on disk in simple
files) it cannot be handled in the storage agnostic part of Jackalope.

In this repository the `VersionHandler` implements a general approach of
versioning valid for all different transport layers. There was also the need
for some refactoring to enable certain operations required for the versioning
support in other transport layers than Jackrabbit.

### Jackalope Doctrine DBAL

Since the Doctrine DBAL transport layer [^14] is the layer of choice for this
thesis, it also had to be touched in order to enable versioning. Its `Client`
class enables the single features described in the specification and functions
as a proxy between the actual storage and the Jackalope. The
`ImplementationLoader` describes which (hopefully successful) tests should be
executed on a test run.

The main parts to work on in this repository were the correct initialization of
the tests and implementing the methods for versioning on the client. These
methods just delegate these tasks to the `VersionHandler` implemented in
Jackalope.

### PHPCR Utils

The PHPCR Utils repository [^15] contains a set of helper classes, which might
be useful to be used in combination with the PHPCR interface. The scope of
these classes vary quite a lot. For example it contains some value converters,
a helper for creating UUID and some commands for execution on the command line.

However, since Jackrabbit was the only implementation for some time, there has
been some code in this repository which should actually have been targeted
solely on Jackrabbit. This code was causing issues with the Doctrine DBAL
transport layer and had also to be refactored.

### PHPCR API Tests

The PHPCR API Tests repository [^16] holds all the tests a PHPCR implementation
has to successfully implement. It can be installed together with Jackalope, if
a developer wants to check an implementation against the PHPCR standard.

The same issue as for the PHPCR Utils apply to this repository. Originally
Jackalope concentrated on the Jackrabbit transport layer, but it is affecting
this repository in a different way. There was no wrong code in this repository,
but there were some missing tests, because the author relied on Jackrabbit's
functionality for a few tasks. Especially the tests for restoring a version and
all the possible edge cases had to be added.

## Design considerations

JCR defines the way the versioning has to be implemented in a content
repository. Since all the metadata for versioning is also stored in nodes and
properties it is not necessary to implement this in a storage specific way.

Figure 9 shows the general architecture, which has been chosen to implement
versioning in Jackalope.

![The general design for the versioning of Jackalope](diagrams/uml/architecture.png)

We decided to implement a `VersionHandler`, which takes care of versioning in
the content repository context. But instead of just using it as a default it is
designed to be plugged into a transport layer. This is possible via an
interface check. So every `Client`, which is the name of the class describing
the transport layer, using the `VersionHandler` has to additionally implement
the `GenericVersioningInterface`.

Another important interface for this thesis is the `VersioningInterface`, which
defines the required methods for the `Client` to support versioning. If the
`VersionHandler` of this thesis is used, these methods only delegate to the
corresponding method in the `VersionHandler`. The `GenericVersioningInterface`
also extends this `VersioningInterface`, because the use of the
`VersionHandler` also assumes that the `VersioningInterface` is used. This way
the `Client` only has to implement one instead of two interfaces.

The `GenericVersioningInterface` also forces the developer to implement a
`setVersionHandler` method. This method is required in order to pass the
`VersionHandler` to the `Client` class via setter injection. Only if this has
been done the `Client` is able to pass all the versioning mechanisms directly
to the `VersionHandler`.

In order to be able to do its work, the `VersionHandler` needs two other
objects. The `Session` object is returned when the user logs into a repository.
It is the central object for working with the repository and allows to
manipulate the data in it. Therefore it works closely together with the second
class the `VersionHandler` uses, which is the `ObjectManager`. This class acts
as mediator between the `Session` and the transport layer's `Client` and as a
Unit of Work, which means that it knows about the state of each node and thus
what has to be saved using the transport layer. Furthermore it acts as a cache
in front of the transport layer having an important influence on performance.

The `VersionHandler` has to use these two classes since it is storing the
versioning information in the nodes and properties specified by JCR. For this
reason the versioning functionality can be implemented in isoliation of the 
transport layer. The `ObjectManager` can easily be used to abstract this
knowledge away from this implementation.

This design was mainly driven by the fact that other transport layers might be
able to do certain operations in a more performance optimized way, e.g. for the
jackrabbit transport layer none of this logic has to be used, because the
database is already capable of handling versioning. The generic
`VersionHandler` will follow the specification in a very strict way, so that it
is garuanteed to work in every imaginable transport layer following the JCR
specification.

## Test setup

### General

The most important piece of software for testing in PHP is PHPUnit[^17]. It's
an implementation of xUnit for PHP, which is a collective name for the shared
architecture of testing frameworks across all major programming languages. The
architecture was introduced by Kent Beck with SUnit for SmallTalk, and the best
known implementation today is JUnit for Java. [see @fowler2006]

The PHPCR API tests are implemented in PHPUnit. This repository contains, among
others, two very important directores. The first one is the `fixtures`
directory offering the sample data for the tests. This data is organized in XML
files, which can easily be used to create a certain database setup for a given
test. The second directory called `tests` consists of the actual PHPUnit test
cases. Both directories are structured using sub directories named after the
chapters in the JCR specification.

The JCR specification defines a lot of different requirements in different
chapters. Since it is not possible to support all these requirements from the
beginning, there has to be an easy way for the implementation to define which
tests are supported, and therefore should be executed. Otherwise it would be
hard to do test driven development supported by continous integration, since
the currently not implemented features would always break the build. Figure 10
shows how this is achieved.

![Test architecture for enabling implementation support](diagrams/uml/test_setup.png)

The `ImplementationLoader` is the class defining which specification chapters
or even single tests are supported by the concrete implementation, and
therefore is located in the concrete implementation's repository. The concrete
implementation must also deliver a `bootstrap.php` file, which is responsible
for declaring the `ImplementationLoader` class in the global namespace.

This `ImplementationLoader` inherits from the `AbstractLoader`, which
introduces some variables containing the unsupported chapters (from the jcr
specification) test cases and even single tests. The `AbstractLoader`
implements the method `getSupportedTest($chapter, $case, $name)`, which will
return a boolean value indicating if the test is supported.

The `BaseCase` inherits from the `PHPUnit_Framework_TestCase`, so that it can
be run using PHPUnit. Additionally it already offers an implementation of the
`setUpBeforeClass` method being executed before the test case, where it gets an
instance of the `ImplementationLoader`. This instance will then be used to
detect if the current test is supported by the current implementation in the
`setUp` method, which is called before every single test by PHPUnit. The
`markTestSkipped` method of PHPUnit is used to skip this test.

With this setup it is also possible to use a continous integration service to
see if the current state of development works as expected, since the not
supported features will not break the build. For Jackalope Doctrine DBAL the
service TravisCI[^18] is used for that, which is also the reason for the
necessity of such an test architecture.

### Doctrine DBAL Transport Layer

The tests for the implementation of the Doctrine DBAL Transport Layer are even
a bit more special, since Doctrine DBAL supports multiple databases. So the
bootstrapping has to identify the database used and, depending on the
database, to inject the correct connection parameters. Since TravisCI should
automatically test against MySQL and PostgreSQL for every change submitted
to GitHub via a Pull Request, there is also the need of a script generating
the correct config based on an environment variable. This script located in the
`tests` directory of the Jackalope Doctrine DBAL repository generates a config
file adapted for the database used before each build on TravisCI.

## Realization

### Initialization of mixin

### Checkin and checkout

#### Creating a frozen node

### Write protection

### Delete a version

### Restore a version

[^13]: <https://github.com/jackalope/jackalope>
[^14]: <https://github.com/jackalope/jackalope-doctrine-dbal>
[^15]: <https://github.com/phpcr/phpcr-utils>
[^16]: <https://github.com/phpcr/phpcr-api-tests>
[^17]: <https://phpunit.de>
[^18]: <https://travis-ci.org>
