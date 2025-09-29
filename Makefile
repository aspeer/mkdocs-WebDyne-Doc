.PHONY : all

SRC_DIR := doc
DOC_DIR := docs
TMP_DIR := doc/build
SCRIPTS_DIR := scripts

all	: $(SRC_DIR)/webdyne.md gh-deploy

webdyne.md0 : webdyne.xml0
	xmllint --xinclude --noent webdyne.xml -o webdyne-db5-expanded.xml	
	pandoc -f docbook -t markdown -o webdyne.md webdyne-db5-expanded.xml
	perl -pi -e 's/\\</</g' $@

$(SRC_DIR)/webdyne.md : $(SRC_DIR)/webdyne.xml
	mkdir -p $(TMP_DIR)
	xmllint --xinclude --noent $< -o $(TMP_DIR)/$(notdir $<)
	pandoc -f docbook -t markdown-smart --lua-filter=$(SCRIPTS_DIR)/admonition-advanced.lua --extract-media=$(DOC_DIR)/images -o $(TMP_DIR)/$(notdir $@) $(TMP_DIR)/$(notdir $<)
	perl -pi -e 's/\\</</g' $(TMP_DIR)/$(notdir $@)
	perl -pi -e 's{\Q./docs/images\E}{images}g' $(TMP_DIR)/$(notdir $@)
	rm -f $(DOC_DIR)/*.md
	perl $(SCRIPTS_DIR)/mdsplit.pl $(TMP_DIR)/$(notdir $@) $(DOC_DIR)

gh-deploy :
	mkdocs gh-deploy -f mkdocs.gh.yml

