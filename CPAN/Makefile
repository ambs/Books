
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

share: book.pdf
	@ rsync -aASPvz book.pdf ambs@eremita:public_html/cpan.pdf

nodraft: build/latex.pl chapters/*.pod tex/asbook.sty
	build/latex.pl -draft=0
	TEXINPUTS=$$TEXINPUTS:tex xelatex book
	makeindex book
	TEXINPUTS=$$TEXINPUTS:tex xelatex book
	TEXINPUTS=$$TEXINPUTS:tex xelatex book

