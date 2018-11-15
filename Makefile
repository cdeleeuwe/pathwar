##
## functions
##

rwildcard = $(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2) $(filter $(subst *,%,$2),$d))

##
## vars
##

GOPATH ?= $(HOME)/go
BIN = $(GOPATH)/bin/pathwar.pw
SOURCES = $(call rwildcard, ./, *.go)
OUR_SOURCES = $(filter-out $(call rwildcard,vendor//,*.go),$(SOURCES))
PROTOS = $(call rwildcard, ./, *.proto)
OUR_PROTOS = $(filter-out $(call rwildcard,vendor//,*.proto),$(PROTOS))
GENERATED_FILES = \
	$(patsubst %.proto,%.pb.go,$(OUR_PROTOS)) \
	$(call rwildcard ./, *.gen.go)
PROTOC_OPTS = -I/protobuf:vendor:.
RUN_OPTS ?=

##
## rules
##

.PHONY: help
help:
	@echo "Make commands:"
	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: \
	  '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | \
	  sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$' | grep -v / | \
	  sed 's/^/  $(HELP_MSG_PREFIX)make /'

.PHONY: run
run: $(BIN)
	$(BIN) server $(RUN_OPTS)

.PHONY: install
install: $(BIN)
$(BIN): .generated $(OUR_SOURCES)
	go install -v

.PHONY: clean
clean:
	rm -f $(GENERATED_FILES) .generated

.PHONY: generate
generate: .generated
.generated: $(OUR_PROTOS)
	rm -f $(GENERATED_FILES)
	go mod vendor
	docker run \
	  --user="$(shell id -u)" \
	  --volume="$(PWD):/go/src/pathwar.pw" \
	  --workdir="/go/src/pathwar.pw" \
	  --entrypoint="sh" \
	  --rm \
	  pathwar/protoc:v1 \
	  -xec "make _generate"
	touch $@

.PHONY: _generate
_generate: $(GENERATED_FILES)

%.pb.go: %.proto
	protoc $(PROTOC_OPTS) --gogoopsee_out=plugins=grpc+graphql:. "$(dir $<)"/*.proto

.PHONY: test
test: .generated
	go test -v ./...
