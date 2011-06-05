
book.pdf: book.tex
	TEXINPUTS=$$TEXINPUTS:tex xelatex book
	makeindex book
	TEXINPUTS=$$TEXINPUTS:tex xelatex book
	TEXINPUTS=$$TEXINPUTS:tex xelatex book

book.tex: build/latex.pl chapters/*.pod tex/asbook.sty
	build/latex.pl

clean:
	find . -name '*~' -delete
	rm -f book.* *.log
