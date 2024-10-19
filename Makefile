.DEFAULT_GOAL := lint
PATH_SEP := $(shell python ./scripts/os/get_path_separator.py)
SCRIPT_PATH := .$(PATH_SEP)scripts$(PATH_SEP)rich$(PATH_SEP)make_text_pretty.py

.PHONY: pre-commit
pre-commit:
	@python $(SCRIPT_PATH) "Make sure 'pre-commit' is installed..."
	@pre-commit uninstall
	@pre-commit install

.PHONY: lint
lint: pre-commit
	@python $(SCRIPT_PATH) "Make sure clean-code rules are observed..."
	@pre-commit run --all-files
	@ruff check --fix
	@echo "lint completed."
