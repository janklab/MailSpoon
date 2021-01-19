# This Makefile lets you build the project and its documentation, run tests,
# package it for distribution, and so on.
#
# Targets provided:
#
#   make doc - Build the project documentation into doc/
#   make test - Run the project Matlab unit tests
#   make toolbox - Build the project as a Matlab Toolbox .mltbx file
#   make dist - Build the project distribution zip files
#   make java - Build your custom Java code in src/ and install it into lib/

# TODO: Should make dist have a dependency on make doc?

PROGRAM=MailSpoon
VERSION=$(shell cat VERSION)
DIST=dist/${PROGRAM}-${VERSION}
DISTFILES=build/Mcode docs lib examples README.md LICENSE CHANGES.txt

.PHONY: test
test:
	./dev-kit/launchtests_mailspoon

.PHONY: build
build:
	./dev-kit/build_mailspoon

.PHONY: doc
doc:
	cd doc-src && ./make_doc
.PHONY: m-doc
m-doc: doc
	rm -rf build/M-doc
	mkdir -p build/M-doc
	cp -R docs/* build/M-doc
	rm -f build/M-doc/feed.xml

.PHONY: toolbox
toolbox: m-doc
	bash package_toolbox.sh

.PHONY: dist
dist: build m-doc
	rm -rf dist/*
	mkdir -p ${DIST}
	cp -R $(DISTFILES) $(DIST)
	cd dist; tar czf ${PROGRAM}-${VERSION}.tgz --exclude='*.DS_Store' ${PROGRAM}-${VERSION}
	cd dist; zip -rq ${PROGRAM}-${VERSION}.zip ${PROGRAM}-${VERSION} -x '*.DS_Store'

.PHONY: java
java:
	cd src/java/MailSpoon-java; mvn package
	cp src/java/MailSpoon-java/target/*.jar lib/java/MailSpoon-java

.PHONY: clean
clean:
	rm -rf dist/* build doc-src/site doc-src/_site M-doc
