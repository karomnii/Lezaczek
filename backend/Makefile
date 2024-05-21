ROOT_DIR:=$(realpath $(shell dirname $(firstword $(MAKEFILE_LIST))))
RUN_TEST_ENV := $(ROOT_DIR)/src/test/env/run_test_env
PHONY: all
all:
	mvn compile

test-build:
	rm -rf target
	mvn compile -P test
	mvn package -P test

run-test-build: test-build
	mvn exec:java

deploy-test-build: test-build
	ssh-keyscan 3.120.246.59 >> ~/.ssh/known_hosts
	scp -i src/test/env/tester target/lezaczek-0.0.1-SNAPSHOT.jar tester@3.120.246.59:/application/spring/lezaczek/lezaczek.jar
	ssh tester@3.120.246.59 '/application/spring/lezaczek/run_test_env'

stop-test-env:
	ssh tester@3.120.246.59 '/application/spring/lezaczek/stop_test_env'