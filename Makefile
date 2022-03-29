.DEFAULT_TARGET: all

all: dist

clean:
	rm -rf lambda/vendor/bundle

deps:
	cd lambda && bundle config set path vendor/bundle && bundle install && bundle config set --local system 'true'

dist: clean deps
	cd lambda && bundle exec ruby zip.rb
