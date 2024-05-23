ifneq ($(ENVIRONMENT), "PRODUCTION")
	TESTER_IDF := src/test/env/tester
	# SQL_SERVER_TESTS := jdbc:sqlserver://localhost
	# TESTER_USER := sa
	# TESTER_PASS := 12345
endif
SERVER_IP := $(SERVER_IP)
VERSION := $(shell mvn help:evaluate -Dexpression=project.version -q -DforceStdout)
build:
	mvn clean
	mvn compile -P production

test-build:
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