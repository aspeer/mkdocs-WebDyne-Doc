.PHONY : all

all	: webdyne.md

webdyne.md : webdyne.xml
	xmllint --xinclude --noent webdyne.xml -o webdyne-db5-expanded.xml	
	pandoc -f docbook -t markdown -o webdyne.md webdyne-db5-expanded.xml
	perl -pi -e 's/\\</</g' $@

clean	: 
	rm -f webdyne.psp webdyne.html $(DIR_EXAMPLE)/*.html

gh-deploy :
	mkdocs gh-deploy -f mkdocs.gh.yml

install :: webdyne.pdf
	cp -R * $(DIR_WEBDYNE_SITE_DOC)
	cp webdyne.pdf $(DIR_WEBDYNE_DEV)/doc
