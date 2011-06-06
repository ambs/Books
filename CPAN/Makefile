
book.pdf: book.tex tex/asbook.sty
	TEXINPUTS=$$TEXINPUTS:tex xelatex book
	makeindex book
	TEXINPUTS=$$TEXINPUTS:tex xelatex book
	TEXINPUTS=$$TEXINPUTS:tex xelatex book

book.tex: build/latex.pl chapters/*.pod
	build/latex.pl

clean:
	find . -name '*~' -delete
	rm -f book.* *.log
