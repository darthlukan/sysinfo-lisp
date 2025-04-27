BUILD_DIR = $(shell pwd)

.PHONY: build
build:
	sbcl --load ./build.lisp

.PHONY: clean
clean:
	rm -rf sysinfo

.PHONY: run
run: build
	./sysinfo
