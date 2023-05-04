#!/bin/bash

DATE=$(shell date +'%y-%m-%d')

CASSETTE=cassette
ESSAYS=essays

TYPES=$(CASSETTE) $(ESSAYS)
TYPES_STRING=$(wordlist 1,$(words $(TYPES)),$(TYPES))
USAGE_STRING="Usage: make commit TYPE=[ $(TYPES_STRING) ]"

.PHONY: all

all: init $(TYPES)

init:
	@$(call dir_check,content/$(CASSETTE))
	@$(call dir_check,content/$(ESSAY))

$(CASSETTE):
	@hugo new --kind post $(CASSETTE)/$(DATE)
	@$(call modify_cassette)

$(ESSAY):
	@hugo new --kind post $(ESSAYS)/$(DATE)

commit:

	file=$(TYPE)/$(DATE)
	$(call do_commit,$(file))
	

define dir_check
	if [ ! -d "$(1)" ]; then \
		mkdir -p $(1); \
	fi
endef

define do_commit
	@echo "Committing $(1)..."
	@hugo
	@git add -A
	@git commit -m "feat: create $(1)"
	@git push
endef

define modify_cassette
	rm -rf "content/$(CASSETTE)/$(DATE)/images"
	sed -i '' -e '2s/title:.*/title: ""/' -e '4s/display:.*/display: blog/' -e '5,7d' "content/$(CASSETTE)/$(DATE)/index.md"
endef
