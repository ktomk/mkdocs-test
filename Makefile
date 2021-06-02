
python ?= python3
pip = $(python) -m pip --disable-pip-version-check
pip_less = | sed '/^Requirement already satisfied: /d;/^\#\#/,$$ d'

.ONESHELL:
shell=bash


.PHONY: test-a-setup test-b-setup
test-a-setup: docs/README.md mkdocs.yml
	$(pip) install --user -U pip wheel setuptools $(pip_less)
	$(python) -m venv venv
	. venv/bin/activate
	python -m pip install mkdocs $(pip_less)
	mkdocs --version

test-b-setup: docs/README.md mkdocs.yml
	$(pip) install --user -U pip wheel setuptools $(pip_less)
	$(python) -m venv venv
	. venv/bin/activate
	python -m pip install -e git+git@github.com:mkdocs/mkdocs.git@769a926691c970ccb8ea0f8efe7d34cc9442576f#egg=mkdocs $(pip_less)
	mkdocs --version

.PHONY: clean
clean:
	pkill -sigint -f 'mkdocs [s]erve'
	rm -rf -- venv docs mkdocs.yml README.md


docs: docs/README.md
	touch $@

docs/README.md: README.md
	mkdir docs
	ln -sfT ../$^ $@

README.md: mkdocs.yml
	touch $@

mkdocs.yml: template/$@
	cp -vp template/$@ $@
