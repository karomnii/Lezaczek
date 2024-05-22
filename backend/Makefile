TESTER_IDF := src/test/env/tester
VERSION := $(shell mvn help:evaluate -Dexpression=project.version -q -DforceStdout)
build:
	rm -rf target
	mvn compile -P production

test-build:
	rm -rf target
	mvn compile -P test

run-test-build: test-build
	mvn exec:java

package-build: build
	mvn package -P production

deploy-build: package-build
	ssh-keyscan 3.79.107.101 >> ~/.ssh/known_hosts
	scp -i $(TESTER_IDF) target/lezaczek-$(VERSION).jar tester@3.79.107.101:/application/spring/lezaczek/lezaczek.jar
	ssh -i $(TESTER_IDF) tester@3.79.107.101 -f '/application/spring/lezaczek/run_prod'

stop-prod:
	ssh -i $(TESTER_IDF) tester@3.79.107.101 -f '/application/spring/lezaczek/stop_prod'