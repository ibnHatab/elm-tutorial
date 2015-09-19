
.PHONY: test

ELM_IO = elm-stuff/packages/maxsnew/IO/1.0.1/elm-io.sh
TESTS=$(wildcard test/*.elm)
TEST_JS=$(patsubst %.elm,%.elm.js,$(TESTS))

test: $(TESTS)
	elm-make --yes $< --output raw-test.js
	$(ELM_IO) raw-test.js $<.js
	node $<.js

clean-test:
	rm $(TEST_JS)

clean: clean-test
