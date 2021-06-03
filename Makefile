
python ?= python3
pip = $(python) -m pip --disable-pip-version-check
pip_less = | sed '/^Requirement already satisfied: /d;/^\#\#/,$$ d'


.ONESHELL:
shell=bash


.PHONY: test-a-setup test-b-setup
setup = $(pip) install --user -U pip wheel setuptools $(pip_less) ; \
	$(python) -m venv venv ; \
	. venv/bin/activate ; \
	python -m pip install $(1) $(pip_less) ; \
	mkdocs --version

test-a-setup: docs/README.md mkdocs.yml
	$(call setup,mkdocs)

test-b-setup: docs/README.md mkdocs.yml
	$(call setup,-e git+ssh://git@github.com/mkdocs/mkdocs.git@refs/pull/2438/head#egg=mkdocs)

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
