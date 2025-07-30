include .env

.DEFAULT_GOAL := lint

SCRIPT_PATH := ./scripts/rich/make_text_pretty.py
NOTES_DIR = notes
GPG_DECRYPT_OPTS = --pinentry-mode loopback

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

.PHONY: clean
clean:
	@python $(SCRIPT_PATH) "Cleaning up *.tar and *.tar.gpg files inside $(NOTES_DIR)/..."
	rm -f $(NOTES_DIR)/*.tar $(NOTES_DIR)/*.tar.gpg
	@echo "Cleanup complete."

.PHONY: encrypt_all
encrypt_all:
	@python $(SCRIPT_PATH) "Starting encryption of all folders inside $(NOTES_DIR)/..."
	@for dir in $(NOTES_DIR)/*/ ; do \
		dirname=$$(basename $$dir); \
		tarfile="$(NOTES_DIR)/$$dirname.tar"; \
		outfile="$(NOTES_DIR)/$$dirname.tar.gpg"; \
		echo "Creating tar archive for $$dir ..."; \
		tar -cvf $$tarfile -C $(NOTES_DIR) $$dirname; \
		echo "Encrypting $$tarfile to $$outfile ..."; \
		gpg --encrypt --recipient "$(GPG_RECIPIENT)" -o $$outfile $$tarfile; \
		rm $$tarfile; \
	done
	@echo "All folders encrypted successfully."

.PHONY: decrypt_all
decrypt_all:
	@python $(SCRIPT_PATH) "Starting decryption and extraction of .tar.gpg files in $(NOTES_DIR)/..."
	@for file in $(NOTES_DIR)/*.tar.gpg ; do \
		filename=$$(basename $$file .tar.gpg); \
		tarfile="$(NOTES_DIR)/$$filename.tar"; \
		destdir="$(NOTES_DIR)/$$filename"; \
		echo "Decrypting $$file to $$tarfile..."; \
		gpg $(GPG_DECRYPT_OPTS) -d $$file > $$tarfile; \
		echo "Extracting $$tarfile into $(NOTES_DIR)/ ..."; \
		mkdir -p $$destdir; \
		tar -xvf $$tarfile -C $(NOTES_DIR)/; \
		rm $$tarfile; \
	done
	@echo "All files decrypted and extracted successfully."
