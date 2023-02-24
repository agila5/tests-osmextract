##
#{{{ Makefile: project global/standard actions
#
# @see: ./notes/usage/readme.md for usage info
#
#}}} \\\


#{{{ [ VARS.* ] /////////////////////////////////////////////////////////////////



# ---(base)------------------------------------------------

ROOT_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))


# ---(project)------------------------------------------------

PACKAGE := $(shell grep '^Package:' DESCRIPTION | sed -E 's/^Package:[[:space:]]+//')


# ---(IMAGES)------------------------------------------------

IMG_MAKE_DIR ?= 'docker/r-images'


# ---(paths)------------------------------------------------

LOGS_DIR ?= ${ROOT_DIR}/logs
TEMP_DIR ?= ${ROOT_DIR}/temp

BUILD_DIRS = ${TEMP_DIR} ${LOGS_DIR}
CLEAN_DIRS = ${TEMP_DIR}

# ---(progs)------------------------------------------------

SHELL := /bin/bash
RSCRIPT := Rscript


#}}} \\\

#{{{ [ COMMANDS.* ] /////////////////////////////////////////////////////////////////

# ---(commands)------------------------------------------------

.PHONY: all test check docs man vignettes readme build install clean init


all: # @HELP/base make: "init,check,test,docs,build"  targets
all: init check test docs build

test: # @HELP/base runs: `devtools::test()`
test: init
	${RSCRIPT} -e 'devtools::test()'


check: # @HELP/base runs: `devtools::check()`
check: init
	${RSCRIPT} -e 'devtools::check()'

docs: # @HELP/base make: "man,readme,vignettes"  targets
docs: man readme vignettes

man: # @HELP/base runs: `devtools::document()`
man: init
	@mkdir -p man
	${RSCRIPT} -e "devtools::document()"

vignettes: # @HELP/base runs: `devtools::build_vignettes()`
vignettes: 
	${RSCRIPT} -e 'devtools::build_vignettes()'

README.md: README.Rmd
	Rscript -e 'devtools::load_all(); knitr::knit("README.Rmd")'
	sed -i.bak 's/[[:space:]]*$$//' $@
	rm -f $@.bak

readme: # @HELP/base runs: `knitr::knit("README.Rmd")` 
readme: README.md

build: # @HELP/base runs: `devtools::build()`
build: 
	${RSCRIPT} -e 'devtools::build()'

install: # @HELP/base runs: `devtools::install()`
install:
	${RSCRIPT} -e 'devtools::install()'

uninstall: # @HELP/base runs: `devtools::uninstall()`
uninstall:
	${RSCRIPT} -e 'devtools::uninstall()'

clean: # @HELP/base clean generated build files
	rm -f src/*.o src/*.so src/*.dll

init: # @HELP/base initialize local (temp,logs) directories
	@mkdir -p ${LOGS_DIR}
	@mkdir -p ${TEMP_DIR}

#}}} \\\

#{{{ [ CUSTOMIZATION.* ] /////////////////////////////////////////////////////////////////

# ---(custom)------------------------------------------------

.PHONY: custom custom-help

custom: # @HELP/custom runs: ./etc/custom/custom.sh for initial project customization
custom: init
	bash ./etc/custom/custom.sh

custom-help: help/custom

#}}} \\\

#{{{ [ ENVIRONMENT.* ] /////////////////////////////////////////////////////////////////

# ---(build)------------------------------------------------

.PHONY: setup prepare update upgrade build-help

prepare: init

setup: # @HELP/build initial build of all podman images
setup:  init prepare build-setup

update: # @HELP/build rebuild of modified podman images
update: init prepare build-update

upgrade: # @HELP/build fresh rebuild of all podman images (pull)
upgrade: init prepare build-upgrade

build-help: help/build

#}}} \\\

#{{{ [ CONTAINERS.* ] /////////////////////////////////////////////////////////////////

# ---(images)------------------------------------------------

.PHONY: build-setup build-update build-upgrade

build-setup:
	cd ${IMG_MAKE_DIR} && $(MAKE) $@

build-update:
	cd ${IMG_MAKE_DIR} && $(MAKE) $@

build-upgrade:
	cd ${IMG_MAKE_DIR} && $(MAKE) $@


# ---(inner check)------------------------------------------------

.PHONY: build-validate

build-validate:
	./runtime.sh build all


# ---(run)------------------------------------------------

.PHONY: runtime-repl runtime-cli runtime-shell runtime-build runtime-command runtime-term runtime-rstudio runtime-help

runtime-repl: # @HELP/runtime ...
runtime-repl:
	cd ${IMG_MAKE_DIR} && $(MAKE) $@

runtime-cli: # @HELP/runtime ...
runtime-cli:
	cd ${IMG_MAKE_DIR} && $(MAKE) $@

runtime-shell: # @HELP/runtime ...
runtime-shell:
	cd ${IMG_MAKE_DIR} && $(MAKE) $@

runtime-build: # @HELP/runtime ...
runtime-build:
	cd ${IMG_MAKE_DIR} && $(MAKE) $@

runtime-command: # @HELP/runtime ...
runtime-command:
	@cd ${IMG_MAKE_DIR} && $(MAKE) --silent $@

runtime-term: # @HELP/runtime ...
runtime-term:
	@cd ${IMG_MAKE_DIR} && $(MAKE) --silent $@

runtime-rstudio: # @HELP/runtime ...
runtime-rstudio:
	cd ${IMG_MAKE_DIR} && $(MAKE) $@

runtime-help: help/runtime

# ---(worker)------------------------------------------------

.PHONY: worker-pack worker-push worker-pull
.PHONY: worker-make worker-test worker-check worker-docs
.PHONY: worker-build worker-install
.PHONY: worker-exec worker-shell

worker-pack: # @HELP/worker ...
worker-pack:
	cd ${IMG_MAKE_DIR} && $(MAKE) $@

worker-push: # @HELP/worker ...
worker-push:
	cd ${IMG_MAKE_DIR} && $(MAKE) $@

worker-pull: # @HELP/worker ...
worker-pull:
	cd ${IMG_MAKE_DIR} && $(MAKE) $@

worker-make: # @HELP/worker ...
worker-make:
	cd ${IMG_MAKE_DIR} && $(MAKE) $@

worker-test: # @HELP/worker ...
worker-test:
	cd ${IMG_MAKE_DIR} && $(MAKE) $@

worker-check: # @HELP/worker ...
worker-check:
	cd ${IMG_MAKE_DIR} && $(MAKE) $@

worker-docs: # @HELP/worker ...
worker-docs:
	cd ${IMG_MAKE_DIR} && $(MAKE) $@

worker-build: # @HELP/worker ...
worker-build:
	cd ${IMG_MAKE_DIR} && $(MAKE) $@

worker-install: # @HELP/worker ...
worker-install:
	cd ${IMG_MAKE_DIR} && $(MAKE) $@

worker-exec: # @HELP/worker ...
worker-exec:
	cd ${IMG_MAKE_DIR} && $(MAKE) $@

worker-shell: # @HELP/worker ...
worker-shell:
	cd ${IMG_MAKE_DIR} && $(MAKE) $@

worker-help:  help/worker

#}}} \\\

#{{{ [ UTILS.* ] /////////////////////////////////////////////////////////////////

# ---(debug)------------------------------------------------

.PHONY: print-%

# Display the value.
# ex. $ make print-REPORT_SOURCE_DIR
# ex. $ make print-IMAGE_REVISION
print-%:
	@echo $* = $($*)

# ---(help)------------------------------------------------

.PHONY: help help%

help/%:
	@echo "NOTE: Use BUILDARCH/BUILDOS variables to override OS/ARCH"
	@echo
	@echo "VARIABLES:"
	@echo "  BINS = $(BINS)"
	@echo "  OS = $(OS)"
	@echo "  ARCH = $(ARCH)"
	@echo "  REGISTRY = $(REGISTRY)"
	@echo "  HOSTARCH = $(HOSTARCH)"
	@echo
	@echo "TARGETS:"
	@grep -E '^.*: *# *@HELP/$*' $(MAKEFILE_LIST) \
	    | awk '                                   \
	        BEGIN {FS = ": *# *@HELP/$*"};        \
	        { sub(/$*-/,"",$$1); printf "  %-30s %s\n", $$1, $$2 };  \
	    '

help: # @HELP/base prints this message
help:  help/base help/build 


#}}} \\\
# vim: set foldmethod=marker :
