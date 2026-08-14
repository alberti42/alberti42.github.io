# Makefile for https://alberti42.github.io (Jekyll 4.3 + minima)
#
# Homebrew's Ruby must come before /usr/bin/ruby on PATH.  This file arranges
# that itself, so every target works from a bare shell, from Emacs (M-x
# compile) or from cron without sourcing find_ruby_path.zsh first.
#
# Run `make` or `make help` for the list of targets.

HOMEBREW_PREFIX ?= $(shell brew --prefix 2>/dev/null || echo /opt/homebrew)
RUBY_BIN        := $(wildcard $(HOMEBREW_PREFIX)/opt/ruby/bin)

# Exporting PATH is what the gems themselves need.  Apple ships GNU make 3.81,
# which execs simple recipe lines itself and resolves them against make's own
# PATH, not the exported one -- so the entry points are spelled absolutely.
ifneq ($(RUBY_BIN),)
export PATH := $(RUBY_BIN):$(PATH)
RUBY   := $(RUBY_BIN)/ruby
BUNDLE := $(RUBY_BIN)/bundle
else
RUBY   := ruby
BUNDLE := bundle
endif
JEKYLL := $(BUNDLE) exec jekyll

# Overridable on the command line, e.g. `make serve PORT=4001`
HOST       ?= 127.0.0.1
PORT       ?= 4000
JEKYLL_ENV ?= development
export JEKYLL_ENV

SITE_URL := http://$(HOST):$(PORT)/

.DEFAULT_GOAL := help
.PHONY: help install update build build-prod serve serve-fast draft doctor \
        check clean distclean open info

help: ## Show this help
	@echo "Targets (make <target>):"
	@grep -hE '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) \
	  | awk -F':.*?## ' '{printf "  \033[1m%-14s\033[0m %s\n", $$1, $$2}'
	@echo
	@echo "Variables: HOST=$(HOST) PORT=$(PORT) JEKYLL_ENV=$(JEKYLL_ENV)"

install: ## Install gems into vendor/bundle (first run / after Gemfile change)
	$(BUNDLE) install

update: ## Update gems to the newest versions allowed by the Gemfile
	$(BUNDLE) update

build: ## Build the site into _site/
	$(JEKYLL) build

build-prod: ## Build as GitHub Pages does (JEKYLL_ENV=production)
	$(MAKE) build JEKYLL_ENV=production

serve: ## Dev server with live reload on HOST:PORT (default 127.0.0.1:4000)
	$(JEKYLL) serve --watch --livereload --host $(HOST) --port $(PORT)

serve-fast: ## Same as serve, but --incremental (fast; can miss cross-page updates)
	$(JEKYLL) serve --watch --livereload --incremental --host $(HOST) --port $(PORT)

draft: ## Dev server including drafts, future-dated and unpublished items
	$(JEKYLL) serve --watch --livereload --drafts --future --unpublished \
	  --host $(HOST) --port $(PORT)

doctor: ## Diagnose deprecated/conflicting configuration
	$(JEKYLL) doctor

check: doctor build-prod ## Run doctor, then a full production build

clean: ## Remove _site/ and .jekyll-cache/
	$(JEKYLL) clean

distclean: clean ## Also remove the installed gems in vendor/
	rm -rf vendor

open: ## Open the running dev server in the default browser
	open $(SITE_URL)

info: ## Print the toolchain versions this Makefile resolves to
	@echo "ruby    : $(RUBY)"; $(RUBY) -v
	@echo "bundler : $(BUNDLE)"; $(BUNDLE) -v
	@$(JEKYLL) -v
