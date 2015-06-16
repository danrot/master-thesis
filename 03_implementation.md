# Implementation

This chapter will explain the main task of this thesis - implementing
versioning in the Doctrine DBAL transport layer of jackalope. 

## Structure

The project is split into many different git repositories. The next sections
will explain each of the repositories, on which work has been done, in order to
complete the goal of implementing versioning for the doctrine dbal transport
layer.

### Jackalope

The Jackalope repository [^10] contains all the code not being coupled to any
specific transport layer. So many implementation details of the JCR
specification have already been implemented in this repository in a storage
agnostic way. The only part which is delegated to one of the transport layers
is the storage.

In this repository the `VersionHandler` implementing a general approach of
versioning valid for all different transport layers. There was also the need
for some refactoring to enable certain operations required for the verisoning
support in other transport layers than Jackrabbit.

### Jackalope Doctrine DBAL

Since the Doctrine DBAL transport layer [^11] is the layer of choice for this
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

The PHPCR Utils repository [^12] contains a set of helper classes, which might
be useful to use in combination with the PHPCR interface. The scope of these
classes vary quite a lot, it contains e.g. some value convertions, a helper for
creating UUID and some commands for execution on the command line.

However, since Jackrabbit was the only implementation for some time, there has
been some code in this repository which should actually have been targeted
solely on Jackrabbit. This code was causing issues with the Doctrine DBAL
transport layer and had also to be refactored.

### PHPCR API Tests

The PHPCR API Tests repository [^13] holds all the tests a PHPCR implementation
has to successfully implement. It can be installed together with Jackalope, if
a developer wants to check an implementation against the PHPCR standard.

The same issue as for the PHPCR Utils apply to this repository. Originally
Jackalope concentrated on the Jackrabbit transport layer, but it utters in a
different way. There was no wrong code in this repository, but there were some
missing tests, because the author relied on Jackrabbit's functionality for a
few tasks. Especially the tests for restoring a version and all the possible
edge cases had to be added.

[^10]: <https://github.com/jackalope/jackalope>
[^11]: <https://github.com/jackalope/jackalope-doctrine-dbal>
[^12]: <https://github.com/phpcr/phpcr-utils>
[^13]: <https://github.com/phpcr/phpcr-api-tests>
