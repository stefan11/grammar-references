STYLE-PATH= ${HOME}/Library/texmf/tex/latex/


all: grammar-references.pdf


# The following creates checked.bib in Biliographien to include all items from my bib that are checked.
# It then adds all items from book projects I was involved in (Headless, Danish, HPSG-Handbook, HPSG-Proceedings).

grammar.bib: ../../Bibliographien/biblio-xdata-en.bib ../../Bibliographien/biblio.bib ../HPSG-Handbook/localbibliography.bib ~/Documents/Dienstlich/Buecher/Editing-New/HPSG-proceedings/hpsg-proceedings.bib ../Germanic/germanic.bib ../Danish/danish.bib
	(cd ../../Bibliographien; make checked.bib)
	(cd ../GT/English; make checked.bib)
#       used before
#	cat ../GT/English/gt.bib ../HPSG-Handbook/hpsg-handbook-bibliography.bib ../Germanic/germanic.bib ../Danish/danish-refs.bib ../Headless/stmue.bib ../Headless/localbibliography.bib > grammar.bib
# alles
	cat ../../Bibliographien/bib-abbr.bib ../../Bibliographien/biblio-xdata-en.bib ../../Bibliographien/checked.bib ../HPSG-Handbook/localbibliography.bib ~/Documents/Dienstlich/Buecher/Editing-New/HPSG-proceedings/hpsg-proceedings.bib ../Danish/danish.bib ../Headless/localbibliography.bib > grammar_tmp.bib
# hpsg_bib.bib is the list of references from the HPSG Bibliography in the web. Script prints BibTeX-entries for unknown titles into new.bib.
	find-new-titles grammar_tmp.bib hpsg_bib.bib
	cat grammar_tmp.bib new.bib > grammar.bib
	biber --tool --no-default-datamodel --configfile=clean-bib-biber-tool.conf --output-field-replace=location:address,journaltitle:journal grammar.bib
	mv grammar_bibertool.bib grammar.bib

quick-bib: ../../Bibliographien/biblio-xdata-en.bib ../../Bibliographien/biblio.bib ../HPSG-Handbook/localbibliography.bib ~/Documents/Dienstlich/Buecher/Editing-New/HPSG-proceedings/hpsg-proceedings.bib ../Germanic/germanic.bib ../Danish/danish.bib
	(cd ../../Bibliographien; make checked.bib)
#	(cd ../GT/English; make checked.bib)
	cat ../../Bibliographien/bib-abbr.bib ../../Bibliographien/biblio-xdata-en.bib ../../Bibliographien/checked.bib ../GT/English/unchecked.bib ../HPSG-Handbook/localbibliography.bib ~/Documents/Dienstlich/Buecher/Editing-New/HPSG-proceedings/hpsg-proceedings.bib ../Danish/danish.bib ../Headless/localbibliography.bib new.bib > grammar.bib
	biber --tool --no-default-datamodel --configfile=clean-bib-biber-tool.conf --output-field-replace=location:address,journaltitle:journal grammar.bib
	mv grammar_bibertool.bib grammar.bib


# as above but biber is called with expansion option 
expanded-grammar.bib: ../../Bibliographien/biblio-xdata-en.bib ../../Bibliographien/biblio.bib ../HPSG-Handbook/localbibliography.bib ~/Documents/Dienstlich/Buecher/Editing-New/HPSG-proceedings/hpsg-proceedings.bib ../Germanic/germanic.bib ../Danish/danish.bib
	(cd ../../Bibliographien; make checked.bib)
#	(cd ../GT/English; make checked.bib)
	cat ../../Bibliographien/bib-abbr.bib ../../Bibliographien/biblio-xdata-en.bib ../../Bibliographien/checked.bib ../GT/English/unchecked.bib ../HPSG-Handbook/localbibliography.bib ~/Documents/Dienstlich/Buecher/Editing-New/HPSG-proceedings/hpsg-proceedings.bib ../Danish/danish.bib ../Headless/localbibliography.bib > expanded-grammar_tmp.bib
	find-new-titles expanded-grammar_tmp.bib hpsg_bib.bib
	cat expanded-grammar_tmp.bib new.bib > expanded-grammar.bib
	biber --tool --no-default-datamodel --configfile=clean-bib-biber-tool.conf --output-resolve --output-field-replace=location:address,journaltitle:journal expanded-grammar.bib
	mv expanded-grammar_bibertool.bib expanded-grammar.bib

zotero-import-grammar.bib: expanded-grammar.bib
	sed 's|\\emph{\([^}]*\)}|<i>\1</i>|g' expanded-grammar.bib |\
	sed 's|\\textsc{\([^}]*\)}|<span style="font-variant:small-caps;">\1</span>|g' |\
	sed 's|\\hyp |-|g' |\
	sed 's|""||g' |\
	sed 's|"\`|„|g' |\
	sed "s|\"\'|“|g" |\
	sed 's|\\slash |/|g'>zotero-import-grammar.bib



todo-bib.unique.txt: grammar-references.bcf
	biber -V grammar-references | grep -i warn | sort -uf > todo-bib.unique.txt

grammar-references.pdf: grammar.bib
	grep @ grammar.bib | egrep -v "string|xdata" | wc -l > count.txt
	xelatex grammar-references
	biber grammar-references
	xelatex grammar-references
	sed -i.backup 's/\\MakeCapital //g' *.adx
	sed -i.backup 's/.*Group.*//' *.adx
	python3 fixindex.py $*.adx
	mv $*mod.adx $*.adx
	makeindex -gs index.format-plus -o $*.and $*.adx
	xelatex grammar-references


index:
	xelatex grammar-references
	sed -i.backup s/.*\\emph.*// grammar-references.adx
	sed -i.backup 's/\\MakeCapital //g' *.adx
	sed -i.backup 's/.*Group.*//' *.adx
	python3 fixindex.py grammar-references.adx
	mv grammar-referencesmod.adx grammar-references.adx
	makeindex -gs index.format-plus -o grammar-references.and grammar-references.adx
	xelatex grammar-references


install:
	cp -p ${STYLE-PATH}abbrev.sty                        styles/
	cp -p ${STYLE-PATH}eng-date.sty                      styles/
	cp -p ${STYLE-PATH}eng-hyp-utf8.sty                  styles/

checked.bib: grammar.bib
	../../Bibliographien/extract-checked-items grammar.bib

clean:
	rm -f *.bak *~ *.log *.blg *.bbl *.aux *.toc *.cut *.out *.tpm *.adx *.idx *.ilg *.ind \
	*.and *.glg *.glo *.gls *.657pk *.adx.hyp *.bbl.old *.ldx *.lnd *.rdx *.sdx *.snd *.wdx \
	*.wdv *.xdv chapters/*.aux *.aux.copy *-blx.bib *.auxlock *.bcf *.mw *.run.xml *.backup \
	chapters/*.aux chapters/*.log chapters/*.aux.copy chapters/*.old chapters/*~ chapters/*.bak chapters/*.backup \
	langsci/*/*.aux langsci/*/*~ langsci/*/*.bak langsci/*/*.backup \


test:
# regexp takes everything till the next bracket
	sed -i.backup 's|\\emph{\([^}]*\)}|<i>\1</i>|g' test.bib
	sed -i.backup 's|\\textsc{\([^}]*\)}|<span style="font-variant:small-caps;">\1</span>|g' test.bib


biber-clean:
	rm -rf `biber --cache`

real-clean: clean biber-clean
