.PHONY: help
help: ## Print list of all commands
		@echo "                  __        __     __  "
		@echo " ___ ___ _  ___  / /__ ____/ /__ _/ /  "
		@echo "/ _ '/  ' \/ _ \/ / -_)___/ / _ '/ _ \ "
		@echo "\_,_/_/_/_/ .__/_/\__/   /_/\_,_/_.__/ "
		@echo "         /_/                           "
		@echo ""
		@grep -E '^[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-50s\033[0m %s\n", $$1, $$2}'

.PHONY: chaincheck
chaincheck: ## Run the chaincheck test suite
		@forge test --mc "Chaincheck"

.PHONY: healthcheck
healthcheck: ## Run the healthcheck test suite
		@forge test --mc "Healthcheck"

.PHONY: invariantcheck
invariantcheck: ## Run the invariantcheck test suite
		@forge test --mc "Invariantcheck"
