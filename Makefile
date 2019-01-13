all:
	@echo "Select target:\n  - debug\n  - release"

debug:
	elm make --output=public/js/main.js --debug src/Main.elm

release:
	elm make --output=public/js/main.js --optimize src/Main.elm
