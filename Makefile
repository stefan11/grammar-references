STYLE-PATH= ${HOME}/Library/texmf/tex/latex/


all: grammar-references.pdf


# currently this includes stmue.bib a subset of stuff in my biblio.bib that may not be included in other books.

grammar.bib: ../../Bibliographien/biblio-xdata-en.bib ../../Bibliographien/checked.bib ../GT/English/unchecked.bib ../HPSG-Handbook/localbibliography.bib ~/Documents/Dienstlich/Buecher/Editing-New/HPSG-proceedings/hpsg-proceedings.bib ../Germanic/germanic.bib ../Danish/danish.bib
#       used before
#	cat ../GT/English/gt.bib ../HPSG-Handbook/hpsg-handbook-bibliography.bib ../Germanic/germanic.bib ../Danish/danish-refs.bib ../Headless/stmue.bib ../Headless/localbibliography.bib > grammar.bib
# alles
	cat ../../Bibliographien/bib-abbr.bib ../../Bibliographien/biblio-xdata-en.bib ../../Bibliographien/checked.bib ../GT/English/unchecked.bib ../HPSG-Handbook/localbibliography.bib ~/Documents/Dienstlich/Buecher/Editing-New/HPSG-proceedings/hpsg-proceedings.bib ../Danish/danish.bib ../Headless/localbibliography.bib > grammar.bib
	biber --tool --configfile=biber-tool.conf --output-field-replace=location:address,journaltitle:journal,date:year grammar.bib
	mv grammar_bibertool.bib grammar.bib

todo-bib.unique.txt: grammar-references.bcf
	biber -V grammar-references | grep -i warn | sort -uf > todo-bib.unique.txt

grammar-references.pdf: grammar.bib
	grep @ grammar.bib | wc -l > count.txt
	xelatex grammar-references
	biber grammar-references
	xelatex grammar-references


install:
	cp -p ${STYLE-PATH}abbrev.sty                      styles/
	cp -p ${STYLE-PATH}eng-date.sty                      styles/
	cp -p ${STYLE-PATH}eng-hyp-utf8.sty                  styles/

clean:
	rm -f *.bak *~ *.log *.blg *.bbl *.aux *.toc *.cut *.out *.tpm *.adx *.idx *.ilg *.ind \
	*.and *.glg *.glo *.gls *.657pk *.adx.hyp *.bbl.old *.ldx *.lnd *.rdx *.sdx *.snd *.wdx \
	*.wdv *.xdv chapters/*.aux *.aux.copy *-blx.bib *.auxlock *.bcf *.mw *.run.xml *.backup \
	chapters/*.aux chapters/*.log chapters/*.aux.copy chapters/*.old chapters/*~ chapters/*.bak chapters/*.backup \
	langsci/*/*.aux langsci/*/*~ langsci/*/*.bak langsci/*/*.backup \


biber-clean:
	rm -rf `biber --cache`

real-clean: clean biber-clean
