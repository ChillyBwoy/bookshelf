all:
	@echo "Select target:\n  - debug\n  - release"

debug:
	elm make --output=public/assets/elm.js --debug src/Main.elm

release:
	elm make --output=public/assets/elm.js --optimize src/Main.elm
