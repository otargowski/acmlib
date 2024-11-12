LATEXCMD = lualatex -shell-escape -output-directory pdf/build/
export TEXINPUTS=.:pdf/kactl-include/:
export max_print_line = 1048576

help:
	@echo "This makefile builds the pdf using KACTL code"
	@echo ""
	@echo "Available commands are:"
	@echo "	make pdf	- to build KACTL"
	@echo "	make test	- to run tests"
	@echo "	make clean	- to remove the pdf"
	@echo "	make help	- to show this information"
	@echo ""
	@echo "For more information see the file 'doc/README'"

pdf:
	$(LATEXCMD) code/main.tex </dev/null
	$(LATEXCMD) code/main.tex </dev/null
	cp pdf/build/main.pdf main.pdf

test: $(patsubst code/%, .make/%, $(shell find code -name 'main.cpp'))

.make/%/main.cpp: code/%/*
	python test.py $(subst .make/, code/, $(@:/main.cpp=))
	mkdir -p $(@D) && touch $@

clean: 
	rm -f main.pdf

.PHONY: help pdf clean test-all
