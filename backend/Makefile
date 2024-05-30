ifneq (,$(wildcard ./.env))
	include .env
	export
endif
ifneq ($(ENVIRONMENT), "PRODUCTION")
	TESTER_IDF := src/test/env/tester
endif
ifeq ($(SQL_SERVER_TESTS),)
SQL_SERVER_TESTS:=$(shell bash -c 'read -p "SQL_SERVER_TESTS variable not defined. Specify now: " SQL_SERVER_TESTS; echo $$SQL_SERVER_TESTS')
endif
ifeq ($(TEST_USER),)
TEST_USER:=$(shell bash -c 'read -p "TEST_USER variable not defined. Specify now: " TEST_USER; echo $$TEST_USER')
endif
ifeq ($(TESTER_PASS),)
TESTER_PASS:=$(shell bash -c 'read -p "TESTER_PASS variable not defined. Specify now: " TESTER_PASS; echo $$TESTER_PASS')
endif
ifeq ($(JWT_SECRET),)
JWT_SECRET:=$(shell bash -c 'read -p "JWT_SECRET variable not defined. Specify now: " JWT_SECRET; echo $$JWT_SECRET')
endif
SERVER_IP := $(SERVER_IP)
VERSION=$(shell mvn help:evaluate -Dexpression=project.version -q -DforceStdout)
.env:
	touch $@
	echo SQL_SERVER_TESTS='$(SQL_SERVER_TESTS)' >> .env; \
	echo TEST_USER=$(TEST_USER) >> .env; \
	echo TESTER_PASS=$(TESTER_PASS) >> .env; \
	echo JWT_SECRET=$(JWT_SECRET) >> .env; \

build: .env
	mvn clean
	mvn compile -P production

test-build: .env
	mvn clean
	mvn compile -P test

run-test-build: test-build
	mvn exec:java

package-build: build
	mvn package -P production

deploy-build: package-build
	ssh-keyscan $(SERVER_IP) >> ~/.ssh/known_hosts
	scp$(if $(filter-out $(ENVIRONMENT), "PRODUCTION"), -i $(TESTER_IDF)) target/lezaczek-$(VERSION).jar tester@$(SERVER_IP):/application/spring/lezaczek/lezaczek.jar
	ssh$(if $(filter-out $(ENVIRONMENT), "PRODUCTION"), -i $(TESTER_IDF)) tester@$(SERVER_IP) -f '/application/spring/lezaczek/run_prod'

stop-prod:
	ssh$(if $(filter-out $(ENVIRONMENT), "PRODUCTION"), -i $(TESTER_IDF)) tester@$(SERVER_IP) -f '/application/spring/lezaczek/stop_prod'