WEEKS=W1 W2 W3 W4 W5 W6 W7
OUTS=$(patsubst %,%.hs,$(WEEKS))
SOLS=$(patsubst %,%Sol.hs,$(WEEKS))

all: $(OUTS)

solutions: $(SOLS)

$(OUTS): %.hs: templ/%B.hs
	@echo "=> $@"
	@mkdir -p $(USER)
	@cp -r W*Test.hs Impl/ stack.yaml haskell-exercises.cabal $(USER)/
	@./Impl/strip 2 < $< > $(USER)/$@

$(SOLS): %Sol.hs: templ/%B.hs
	@echo "=> $@"
	@mkdir -p $(USER)
	@cp -r W*Test.hs Impl/ stack.yaml haskell-exercises.cabal $(USER)/
	@./Impl/strip 1 < $< > $(USER)/$@
