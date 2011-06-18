
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

dropbox: book.pdf
	@ cp -v book.pdf ~/'Dropbox/Shared/share ambs mjsr/CPAN Modules and Frameworks/cpan.pdf'
	@ cp -v book.pdf ~/Dropbox/Public/cpan.pdf

nodraft: build/latex.pl chapters/*.pod tex/asbook.sty
	build/latex.pl -draft=0
	TEXINPUTS=$$TEXINPUTS:tex xelatex book
	makeindex book
	TEXINPUTS=$$TEXINPUTS:tex xelatex book
	TEXINPUTS=$$TEXINPUTS:tex xelatex book

