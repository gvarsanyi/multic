.PHONY: test build clean

build:
	@npm install
	@echo "BUILD coffee-script"
	@rm -rf js/
	@node_modules/.bin/coffee -b -o js/ coffee/
	@echo " -- done"

test: build
	@./node_modules/.bin/mocha --require chai --compilers coffee:coffee-script/register --recursive
	@rm -rf tmp/
