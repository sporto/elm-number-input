docs:
	elm-make --docs=documentation.json

run-example:
	cd example && npm start

build-docs:
	rm -rf docs/*
	NODE_ENV=production cd example && npm run build

.PHONY: example
