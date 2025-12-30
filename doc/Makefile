.PHONY : all

TMPDIR := build
SCRIPTS := ../scripts
DOCS := ../docs

all	: webdyne.md

webdyne.md : webdyne.xml
	mkdir -p $(TMPDIR)
	xmllint --xinclude --noent $< -o $(TMPDIR)/$<
	pandoc -f docbook -t markdown-smart --lua-filter=../scripts/admonition-advanced.lua --lua-filter=../scripts/links-target-blank.lua --extract-media=$(DOCS)/images -o $(TMPDIR)/$@ $(TMPDIR)/$<
	perl -pi -e 's/\\</</g' $(TMPDIR)/$@
	perl -pi -e 's{\Q../docs/images\E}{images}g' $(TMPDIR)/$@
	rm -f $(DOCS)/*.md
	perl $(SCRIPTS)/mdsplit.pl $(TMPDIR)/$@ $(DOCS)

clean	: 
	#rm -f webdyne.psp webdyne.html $(DIR_EXAMPLE)/*.html
