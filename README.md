# About

This project is a quick-start documentation of [DocBook](http://docbook.org/). The [LOCKSS Team](http://www.lockss.org/) has bundled up a tool chain to process DocBook documents into PDF documents using XSL Formatting Objects (XSL-FO) and Apache FOP 2.1. 

## Requirements

- Java 6 or newer
- Git

## Compile document

In order to generate a PDF run

  `bin/makedoc -pdf FILE...`

on one or more DocBook XML files, and PDF files with corresponding names will be
generated.

Try it on the provided DocBook primer (docbook-quick-start.xml) using:

  `bin/makedoc -pdf docbook-quick-start.xml`

