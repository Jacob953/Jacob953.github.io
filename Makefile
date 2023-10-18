#!/bin/bash

DATE=$(shell date +'%y-%m-%d')

CASSETTE=cassette
ESSAYS=essays

TYPES=$(CASSETTE) $(ESSAYS)
TYPES_STRING=$(wordlist 1,$(words $(TYPES)),$(TYPES))
USAGE_STRING="Usage: make commit TYPE=[ $(TYPES_STRING) ]"

init: ## initial target folder with types
	@$(call dir_check,content/$(CASSETTE))
	@$(call dir_check,content/$(ESSAYS))

$(CASSETTE):
	@hugo new --kind post $(CASSETTE)/$(DATE)
	@$(call modify_cassette)

$(ESSAYS):
	@hugo new --kind post $(ESSAYS)/$(DATE)

commit: ## commit to gh-page
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

define date

endef

.DEFAULT_GOAL := help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
