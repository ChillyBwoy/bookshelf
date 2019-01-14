all:
	@echo "Select target:\n  - debug\n  - release"

debug:
	elm make --output=public/js/elm.js --debug src/Main.elm

release:
	elm make --output=public/js/elm.js --optimize src/Main.elm

devserver:
	python3 -m http.server -d ./public
