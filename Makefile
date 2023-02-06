#
# Makefile to build and test the application
#   duplicates (and should be kept in sync with) some of the scripts in package.json
#

# force the shell used to be bash in case for some commands we want to use
# set -o pipefail ex:
#    set -o pipefail ; SOMECOMMAND 2>&1 | tee $(LOG_FILE)
SHELL=/bin/bash

# Test if a variable has a value, callable from a recipe
# like $(call ndef,ENV)
ndef = $(if $(value $(1)),,$(error $(1) not set))

GIT_TAG_VERSION = $(shell git describe)

LINT = ./node_modules/.bin/eslint
STYLELINT = ./node_modules/.bin/stylelint
TSC = ./node_modules/.bin/tsc
BUNYAN = ./node_modules/.bin/bunyan

LINT_LOG = logs/lint.log

# Add --quiet to only report on errors, not warnings
LINT_OPTIONS = --ext .js --ext .ts
LINT_FORMAT = stylish

.DEFAULT_GOAL := help
.DELETE_ON_ERROR :
.PHONY : all init install build lint-log vim-lint lint stylelint test clean clean-build pack help

all : lint build test ## run lint, build, test

init : install build ## run install, build; intended for initializing a fresh repo clone

install : ## run npm install
	npm install

build : ## build the package for publishing
	npm run build

release : ## run standard-version to bump the version and create a changelog (edit before pushing)
	npm run release

postrelease : ## update release version after merging release tag back to develop
	npm version preminor --preid=dev

bump-dev-version: ## Increment the development version in package.json and package-lock.json
	npm version prerelease
	git tag -d $$(git tag --points-at HEAD)

lint-log : LINT_OPTIONS += --output-file $(LINT_LOG) ## run lint concise diffable output to $(LINT_LOG)
lint-log : LINT_FORMAT = unix
vim-lint : LINT_FORMAT = unix ## run lint in format consumable by vim quickfix
lint : stylelint ## run lint over the sources & tests & styles; display results to stdout
lint vim-lint lint-log :
	-$(LINT) $(LINT_OPTIONS) --format $(LINT_FORMAT) src
	-$(TSC) --noEmit --skipLibCheck

lint-ci: ## run stylelint and lint for CI (fail if there are errors)
	$(LINT) $(LINT_OPTIONS) --format $(LINT_FORMAT) src

run : ## run the app (npm start)
	npm start | $(BUNYAN)

run-dev : ## run the app for development (using nodemon to rerun as sources are modified)
	npm run start:dev

test : ## run the tests defined in package.json
	npm run test

clean : clean-build ## remove ALL created artifacts

clean-build : ## remove all artifacts created by the build target
	-rm -fr dist/*

pack : ## run npm pack which creates a tarball (.tgz) of what would be published
	npm pack

## Help documentation à la https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
## if you want the help sorted rather than in the order of occurrence, pipe the grep to sort and pipe that to awk
help :
	@echo ""                                             ; \
	echo "Useful targets in this riff-metrics Makefile:" ; \
	(grep -E '^[a-zA-Z_-]+ ?:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = " ?:.*?## "}; {printf "\033[36m%-20s\033[0m : %s\n", $$1, $$2}') ; \
	echo ""
