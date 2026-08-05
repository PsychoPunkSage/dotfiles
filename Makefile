# Dotfiles Makefile
#
# This repo doubles as ~/.config on the machine it was authored on, so on
# that machine each managed tool's source dir and its live config path are
# the same file (self-linked). On any other machine, clone this repo
# somewhere (e.g. ~/dotfiles) and run `make all` / `make <tool>` to symlink
# the managed configs into place under ~/.config, without touching anything
# else already living there.

CONFIG_DIR := $(HOME)/.config
REPO_DIR   := $(CURDIR)

TOOLS := ghostty tmux nvim hypr

# Firefox profile lives outside ~/.config (snap confinement blocks symlinks
# back into hidden dirs like ~/.config), so userChrome.css is copied instead
# of symlinked. Re-run `make firefox` after editing firefox/userChrome.css.
FIREFOX_PROFILE := $(firstword $(wildcard $(HOME)/snap/firefox/common/.mozilla/firefox/*.default) $(wildcard $(HOME)/.mozilla/firefox/*.default*))

.PHONY: all $(TOOLS) firefox status help

all: $(TOOLS) firefox

$(TOOLS):
	@src="$(REPO_DIR)/$@"; \
	dst="$(CONFIG_DIR)/$@"; \
	if [ "$$(readlink -f "$$src")" = "$$(readlink -f "$$dst" 2>/dev/null)" ]; then \
		echo "[$@] already in place -> $$dst"; \
	elif [ -L "$$dst" ]; then \
		echo "[$@] replacing stale symlink: $$dst -> $$src"; \
		rm "$$dst"; \
		ln -s "$$src" "$$dst"; \
	elif [ -e "$$dst" ]; then \
		backup="$$dst.bak-$$(date +%Y%m%d%H%M%S)"; \
		echo "[$@] backing up existing $$dst -> $$backup"; \
		mv "$$dst" "$$backup"; \
		ln -s "$$src" "$$dst"; \
		echo "[$@] linked $$dst -> $$src"; \
	else \
		ln -s "$$src" "$$dst"; \
		echo "[$@] linked $$dst -> $$src"; \
	fi

firefox:
	@if [ -z "$(FIREFOX_PROFILE)" ]; then \
		echo "[firefox] no profile found under ~/snap/firefox or ~/.mozilla, skipping"; \
	else \
		mkdir -p "$(FIREFOX_PROFILE)/chrome"; \
		cp "$(REPO_DIR)/firefox/userChrome.css" "$(FIREFOX_PROFILE)/chrome/userChrome.css"; \
		echo "[firefox] copied userChrome.css -> $(FIREFOX_PROFILE)/chrome/userChrome.css"; \
		if ! grep -q 'legacyUserProfileCustomizations' "$(FIREFOX_PROFILE)/user.js" 2>/dev/null; then \
			echo 'user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);' >> "$(FIREFOX_PROFILE)/user.js"; \
			echo "[firefox] enabled legacyUserProfileCustomizations.stylesheets in user.js"; \
		fi; \
		echo "[firefox] restart Firefox for changes to take effect"; \
	fi

status:
	@for t in $(TOOLS); do \
		src="$(REPO_DIR)/$$t"; \
		dst="$(CONFIG_DIR)/$$t"; \
		if [ "$$(readlink -f "$$src")" = "$$(readlink -f "$$dst" 2>/dev/null)" ]; then \
			echo "[$$t] OK -> $$dst"; \
		else \
			echo "[$$t] NOT LINKED (expected $$dst -> $$src)"; \
		fi; \
	done

help:
	@echo "Usage:"
	@echo "  make all        Link ghostty, tmux, nvim, hypr configs into ~/.config, and copy firefox userChrome.css"
	@echo "  make <tool>     Link a single tool: ghostty | tmux | nvim | hypr"
	@echo "  make firefox    Copy firefox/userChrome.css into the live Firefox profile"
	@echo "  make status     Show link status for managed tools"
