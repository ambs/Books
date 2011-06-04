book.pdf: book.tex
	TEXINPUTS=$$TEXINPUTS:tex xelatex book.tex
	TEXINPUTS=$$TEXINPUTS:tex xelatex book.tex
	TEXINPUTS=$$TEXINPUTS:tex xelatex book.tex

book.tex: build/latex.pl chapters/*.pod tex/asbook.sty
	build/latex.pl


