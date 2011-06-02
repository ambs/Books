book.pdf: book.tex
	xelatex book.tex

book.tex: build/latex.pl \
	  chapters/database.pod  chapters/oo.pod chapters/xml.pod\
	  chapters/intro.pod     chapters/templates.pod\
	  chapters/markup.pod    chapters/web.pod
	build/latex.pl


