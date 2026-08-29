# Makefile for https://alberti42.github.io (Hugo + Congo, authored in Org)
#
# The content pipeline is:
#
#     content-org/**/*.org  --(ox-hugo, `make export')-->  content/**/*.md
#     content/**/*.md       --(hugo,   `make build')  -->  public/
#
# The Markdown in content/ is a committed build artefact, so CI needs Hugo
# only -- no Emacs, no Ruby.
#
# Run `make` or `make help` for the list of targets.

# Hugo comes from Homebrew and Emacs from ~/.local/bin, neither of which is on
# the default PATH of a GUI Emacs started from Finder, or of cron.  Arrange it
# here so every target works from a bare shell -- the same trick the old
# Jekyll Makefile used for Ruby.
#
# Apple ships GNU make 3.81, which execs simple recipe lines itself and
# resolves them against make's own PATH rather than the exported one, so the
# entry points are resolved to absolute paths up front.
HOMEBREW_PREFIX ?= $(shell brew --prefix 2>/dev/null || echo /opt/homebrew)
TOOL_PATH       := $(HOMEBREW_PREFIX)/bin:$(HOME)/.local/bin:$(PATH)
export PATH     := $(TOOL_PATH)

HUGO        ?= $(shell PATH="$(TOOL_PATH)" command -v hugo        || echo hugo)
EMACS       ?= $(shell PATH="$(TOOL_PATH)" command -v emacs       || echo emacs)
EMACSCLIENT ?= $(shell PATH="$(TOOL_PATH)" command -v emacsclient || echo emacsclient)

# Hugo and Org both read UTF-8 sources.
export LC_ALL ?= en_US.UTF-8
export LANG   ?= en_US.UTF-8

HOST ?= 127.0.0.1
PORT ?= 1313

ORG_SOURCES := $(shell find content-org -name '*.org' 2>/dev/null)

.DEFAULT_GOAL := help
.PHONY: help export new-post edit hooks serve serve-drafts build build-prod \
        theme-update check clean distclean open info

help: ## Show this help
	@echo "Targets (make <target>):"
	@grep -hE '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) \
	  | awk -F':.*?## ' '{printf "  \033[1m%-14s\033[0m %s\n", $$1, $$2}'
	@echo
	@echo "Variables: HOST=$(HOST) PORT=$(PORT)"

export: ## Export content-org/*.org -> content/*.md via ox-hugo
	$(EMACS) --batch -l scripts/ox-hugo-export.el

new-post: ## Scaffold a post: make new-post SECTION=emacs SLUG=my-post
	@test -n "$(SECTION)" || { echo "usage: make new-post SECTION=emacs SLUG=my-post"; exit 1; }
	@test -n "$(SLUG)"    || { echo "usage: make new-post SECTION=emacs SLUG=my-post"; exit 1; }
	@mkdir -p content-org/$(SECTION)
	@test ! -e content-org/$(SECTION)/$(SLUG).org || \
	  { echo "content-org/$(SECTION)/$(SLUG).org already exists"; exit 1; }
	@sed -e 's|@TITLE@|$(SLUG)|g' \
	     -e "s|@DATE@|$$(date '+<%Y-%m-%d %a>')|g" \
	     -e 's|@SECTION@|$(SECTION)|g' \
	     -e 's|@SLUG@|$(SLUG)|g' \
	     archetypes/post.org > content-org/$(SECTION)/$(SLUG).org
	@echo "created content-org/$(SECTION)/$(SLUG).org"
	@$(MAKE) --no-print-directory edit FILE=content-org/$(SECTION)/$(SLUG).org

hooks: ## Enable the repo's git hooks (.githooks/) for this clone
	@git config core.hooksPath .githooks
	@echo "core.hooksPath -> .githooks"
	@echo "  pre-commit: re-exports Org sources and stages the generated Markdown"

edit: ## Open FILE in the running Emacs daemon (no-op if none); NO_OPEN=1 skips
	@test -n "$(FILE)" || { echo "usage: make edit FILE=path"; exit 1; }
	@if [ -n "$(NO_OPEN)" ]; then \
	  exit 0; \
	elif ! command -v $(EMACSCLIENT) >/dev/null 2>&1; then \
	  echo "  (emacsclient not found -- open it yourself)"; \
	elif ! $(EMACSCLIENT) -e t >/dev/null 2>&1; then \
	  echo "  (no Emacs daemon running -- open it yourself)"; \
	elif [ "$$($(EMACSCLIENT) -e '(length (visible-frame-list))' 2>/dev/null)" = "0" ]; then \
	  $(EMACSCLIENT) -n -c "$(FILE)" && echo "  opened in a new Emacs frame"; \
	else \
	  $(EMACSCLIENT) -n "$(FILE)" && echo "  opened in the running Emacs"; \
	fi

serve: export ## Export, then run the live-reloading dev server
	$(HUGO) server --bind $(HOST) --port $(PORT) --navigateToChanged

serve-drafts: export ## Same as serve, but also shows drafts and future posts
	$(HUGO) server --bind $(HOST) --port $(PORT) --navigateToChanged --buildDrafts --buildFuture

build: export ## Export, then build the site into public/
	$(HUGO) --gc --minify --cleanDestinationDir

build-prod: build ## Alias for build (this is exactly what CI runs)

check: ## Build with warnings promoted to errors, as CI does
	$(HUGO) --gc --minify --cleanDestinationDir --panicOnWarning

theme-update: ## Update the Congo theme module to its latest release
	$(HUGO) mod get -u ./...
	$(HUGO) mod tidy

clean: ## Remove the build output and Hugo's caches
	rm -rf public resources .hugo_build.lock

distclean: clean ## Also remove the repo-local ox-hugo installation
	rm -rf .emacs-packages

open: ## Open the running dev server in the default browser
	open http://$(HOST):$(PORT)/

info: ## Print the toolchain versions this Makefile resolves to
	@echo "hugo   : $$($(HUGO) version)"
	@echo "emacs  : $$($(EMACS) --version | head -1)"
	@echo "daemon : $$($(EMACSCLIENT) -e t >/dev/null 2>&1 && echo "running ($$($(EMACSCLIENT) -e '(length (visible-frame-list))') visible frame(s))" || echo "not running")"
	@echo "org sources: $(words $(ORG_SOURCES)) file(s)"
	@echo "git hooks  : $$(git config core.hooksPath 2>/dev/null || echo 'not enabled -- run: make hooks')"
