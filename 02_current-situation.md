# Current situation
This chapter will introduce the current situation in more detail. Figure 1 
presents the dependencies as a layer digram. On top of is our CMF, which makes
use of some components from the Symfony CMF. The Symfony CMF, an open source
project initiated by the swiss agency Liip[^9], depends on Symfony and PHPCR.
PHPCR is, as already described, just an interface for accessing a content
repository. The actual implementation Sulu uses is Jackalope, for which two
transport layers are available, one for Doctrine DBAL and one for Jackrabbit.

![The layer architecture of Sulu](diagrams/overview.png)

The following paragraphs will explain each of this components separately.

## Symfony2
As already mentioned, Symfony2 is the most important framework used by Sulu.
It can be used as a standalone set of php components, or as a php framework for
building web applications. [see @symfony2014a]

It offers different functionalities widely used by different web applications,
like dependency injection, event dispatching, form rendering and interpreting,
localization, routing URLs and authorization. [see @symfony2014b]

Symfony2 also leverages the concept of bundles. A bundle contains all the
public (stylesheets, scripts, images, fonts, ...) and non-public files (php,
configuration definitions, ...) implementing a certain feature.
[see @symfony2014c]

This feature makes it easily possible to share code written for Symfony2 across
different projects. The Sulu project offers multiple of these bundles, which
can be separately activated or deactivated. Sulu is also using many other third
party and symfony bundles.

## PHPCR

## Jackalope

## Doctrine DBAL

## Jackrabbit

## Symfony CMF

[^9]: <http://www.liip.ch>
