---
title:  Versioning for content management systems using the example of
    Jackalope Doctrine DBAL
author: Daniel Rotter, BSc
matriculation: 1310249002
submissiontown: Altach
submissiondate: July 2015
abstract:
    - Versioning is a very important part of any system trying to manage
      content or documents. So this thesis is about introducing versioning into
      Jackalope Doctrine DBAL, which is an implementation of a so called
      content repository. Such a content repository is defined by the PHPCR
      specification, where it is described as a way to handle hierarchical
      semi-structured data in a semantic way. The main use case of such a
      content repository is a content management system.
    - Versioning is already specified in PHPCR, but currently not implemented
      in the implementation for relational databases, which uses Doctrine DBAL
      as an abstraction layer. The goal of this thesis is to implement this
      support according to the specification. Ideally these changes will be
      merged into the official library, in order to be available and further
      maintainable for everyone.
    - This thesis will also try to analyze the problems occuring while
      implementing this functionality. Some of these problems are caused by the
      fact, that this project started as pure client for Jackrabbit, another
      content repository written in Java. Of course the thesis will also try to
      suggest better alternatives to the existing problems.
    - For this reason also the versioning mechanisms of other systems with a
      high priority on versioning are compared, this includes Jackrabbit,
      product lifecycle management systems and version control systems. Whereby
      the latter one is divided into a general part and a part about git, a
      version control system originally developed for Linux and growing in
      popularity.
    - The result of this thesis is an implementation of versioning in Jackalope
      Doctrine DBAL, containing the most important features, including creating
      and restoring versions. Removing versions have been omitted by intent,
      since this is not a requirement for most users. It was also not possible
      to follow the specification in every single detail, because of some
      missing but required functionality in the implementation.
zusammenfassung:
    - Versionierung ist ein sehr wichtiger Teil jedes Systems, welches versucht
      Inhalte oder Dokumente zu verwalten. Diese Arbeit ist über das Einführen
      einer solchen Versionierung in Jackalope Doctrine DBAL, eine
      Implementierung eines Content Repositories. Solch ein Content Repository
      ist in der PHPCR Spezifikation definiert, wo es als besonders geeignet
      für hierarchische, teils strukturierte, semantische Daten beschrieben
      wird. Der Hauptanwendungsfall für ein Content Repository ist ein Content
      Management System.
    - Versionierung ist bereits in PHPCR spezifiziert, aber noch nicht in der 
      Implementierung für relationale Datenbanken enthalten, welche Doctrine
      DBAL als Abstraktionsschicht verwendet. Das Ziel dieser Arbeit ist die
      Implementierung der Versionierung laut der Spezifikation. Im Idealfall
      werden diese Änderungen in das offiziele Projekt übernommen, damit sie
      für alle verwendbar und selber zu verbessern sind.
    - Diese Arbeit wird auch versuchen die Probleme, die während der
      Implementierung auftauchen, zu analysieren. Einige dieser Probleme treten
      auf Grund der Tatsache, dass das Projekt als purer Client für Jackrabbit,
      einem weiteren Content Repository geschrieben in Java, gestart wurde,
      auf. Natürlich wird diese Thesis auch besser Alternativen für diese
      Probleme zu erläutern.
    - Aus diesem Grund werden auch die Versionierungsmechanismen von anderen
      Systemen mit einer hohen Priorisierung auf Versionierung verglichen. Dazu
      gehören Jackrabbit, Product Lifecycle Management Systeme und 
      Versionskontrollsysteme. Wobei das letzter in einen generellen und einen
      Teil über Git, einem Versionskontrollsystem das für die Linux Entwicklung
      geschrieben wurde und immer populärer wird, geteilt ist.
    - Das Ergebnis der Arbeit ist eine Implementierung der Versionierung in
      Jackalope Doctrine DBAL, welche die wichtigsten Funktionalitäten, das
      Erstellen und Wiederherstellen von Versionen, beinhalten. Das Löschen von
      Versionen wurde bewusst nicht implementiert, da es von den meisten
      Benutzern nicht benötigt wird. Es war leider auch nicht möglich die
      Spezifikation in jedem einzelnen Detail zu befolgen, da einige benötigte
      Funktionen in dieser Implementierung fehlen.
---
