CHAPTERS=cpan-chapter1.pdf cpan-chapter2.pdf cpan-chapter3.pdf

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

share: book.pdf $(CHAPTERS)
	@ rsync -aASPvz book.pdf ambs@eremita:public_html/cpan.pdf
	@ rsync -aASPvz $(CHAPTERS) ambs@camelo:public_html

cpan-chapter1.pdf: book.pdf
	pdfjam -q book.pdf  7-14 -o cpan-chapter1.pdf

cpan-chapter2.pdf: book.pdf
	pdfjam -q book.pdf 15-26 -o cpan-chapter2.pdf

cpan-chapter3.pdf: book.pdf
	pdfjam -q book.pdf 27-44 -o cpan-chapter3.pdf

nodraft: build/latex.pl chapters/*.pod tex/asbook.sty
	build/latex.pl -draft=0
	TEXINPUTS=$$TEXINPUTS:tex xelatex book
	makeindex book
	TEXINPUTS=$$TEXINPUTS:tex xelatex book
	TEXINPUTS=$$TEXINPUTS:tex xelatex book

