SHELL := /bin/bash

.DEFAULT_GOAL := help

##@ Utility
help: 								## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make [command] \033[36m\033[0m\n"} /^[a-zA-Z0-9 _-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

install:     ## Install worktree
	@echo ""
	@echo $$(echo "Installing ╦ ╦┌─┐┬─┐┬┌─┌┬┐┬─┐┌─┐┌─┐")
	@echo $$(echo "...........║║║│ │├┬┘├┴┐ │ ├┬┘├┤ ├┤ ")
	@echo $$(echo "...........╚╩╝└─┘┴└─┴ ┴ ┴ ┴└─└─┘└─┘")
	@echo ""
	@echo "It's going to ask for your sudo password..."
	@echo ""
	@sudo cp worktree.sh /usr/local/bin/wo
	@sudo chmod +x /usr/local/bin/wo
	@echo ""
	@echo "Worktree installed! You can use it as \"wo\" in your terminal."

uninstall:		## Uninstall worktree
		@sudo rm /usr/local/bin/wo
		@echo "Uninstalled worktree"
