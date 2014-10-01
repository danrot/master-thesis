# Introduction
MASSIVE ART WebServices in Dornbirn is currently implementing a new open source
content management framework named Sulu. The most fundamental base for this
project is the PHP framework Symfony2. Another important part of Sulu is the
PHPCR, which is a project defining some interfaces for a content repository.
This specification is based on JCR (Java Content Repository).

The concrete implementation of this interface used by Sulu is Jackalope, which
also includes some different transport layers. At the moment there are layers
for Jackrabbit, which is an implementation of a content repository from the
apache foundation, and for doctrine dbal, which is database abstraction layer.
This means that you can also use a relational database as a content repository.

Jackrabbit already supports versioning of content, so it was very easy to
implement in Jackalope. However, at the moment the doctrine dbal transport
layer does not have any versioning capabilities. The goal of this thesis is to
add this functionality to this transport layer.

The biggest challenges for this implementation is to find a good and performant
way to store the different versions in a relational database. Therfore the
already existing schema has to be extended, which has also to be accepted by
the open source community.

Another problem-causing issue could be the fact that the versioning is working
only on Jackrabbit at the moment. The interface definition is designed for the
usage with this database, so another implementation would be a great way to
check if the interface also fits for the more general approach, which PHPCR is
actually targeting.

There are also plans for versioning functionalities in Sulu, which would make
use of this implementation. Since this CMF has some very special types of
content, there will be even more problems to face. For instance pages can have
links to other pages, whereby these links have to be versioned as well. Then it
is not completely clear if the referenced pages need to be stored in an own
version as well. An even bigger challenge is the versioning of a smart content,
which filters other pages by certain criteria. If these criteria are versioned,
the result would not be the same after restoring an older version, whether this
is intented or not.

A very interesting use case, which could already be useful for some clients of
MASSIVE ART, is to surf the content of the website from a specific date. This
would especially be helpful for legal concerns, e.g. if a company gets sued for
having a wrong, damage-causing manual on their website.

