all:
	case $$USER in \
	nemo157) \
		latexmake report \
	;; \
	simon) \
		latexmk -pdf report; \
	;; \
	*) \
		pdflatex report.tex; \
		bibtex report; \
		pdflatex report.tex; \
		pdflatex report.tex; \
	;; \
esac

clean:
	latexmk -pdf -C report

sclean:
	rm -rf report.aux
	rm -rf report.log
	rm -rf report.out

