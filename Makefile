.PHONY : all

SRC_DIR := doc
TMP_DIR := $(SRC_DIR)/build
PSP_DIR := $(SRC_DIR)/example
PSP_FILES := $(shell find $(PSP_DIR) -type f -name '*.psp')

DOC_DIR := docs
SCRIPTS_DIR := scripts


DOCKER_DIR := docker
DOCKER_IMAGE := webdyne-mkdocs:latest
DOCKER_STAMP := $(DOCKER_DIR)/.built

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

gh-deploy : $(SRC_DIR)/webdyne.md
	mkdocs gh-deploy -f mkdocs.gh.yml

serve : $(SRC_DIR)/webdyne.md docker
	docker rm -f webdyne-mkdocs || true
	docker run -d --name webdyne-mkdocs -e PORT=5000 -p 5000:5000 webdyne-mkdocs
	mkdocs serve -f mkdocs.local.yml

docker: $(DOCKER_STAMP)

$(DOCKER_STAMP) : $(PSP_FILES) docker/Dockerfile.alpine
	docker build  -t $(DOCKER_IMAGE) -f docker/Dockerfile.alpine .
	touch $(DOCKER_STAMP)
