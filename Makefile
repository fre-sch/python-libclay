ifndef VIRTUAL_ENV
$(error VIRTUAL_ENV is not set, make sure to run this in python virtualenv)
endif

.PHONY: all install clean package

all: package

install:
	python3 -m venv .venv
	source .venv/bin/activate
	pip install -r requirements

clean:
	rm -rf libclay/__pycache__
	rm -f libclay/*.c
	rm -f libclay/*.json
	rm -f libclay/_clay.pxd
	rm -f libclay/_wrapper.{pyx,pxd}

package: setup.py libclay/__init__.py libclay/_macro.pyx libclay/_clay.json libclay/_clay.pxd libclay/_wrapper.pyx
	python setup.py build_ext --inplace

libclay/_clay.json: make_json.py libclay/clay.h
	python -m make_json libclay/clay.h libclay/_clay.json

libclay/_clay.pxd: libclay/clay.h
	autopxd libclay/clay.h libclay/_clay.pxd
	patch -p1 < clay_pxd.patch

libclay/_wrapper.pyx: make_wrappers.py libclay/_clay.json
	python -m make_wrappers libclay/_clay.json libclay/_wrapper.pyx
