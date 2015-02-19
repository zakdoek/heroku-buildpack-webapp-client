#!/usr/bin/env bash

# Install compass
status "Installing Compass"
RUBY_VERSION=$(ruby -e "require 'rbconfig';puts \"#{RUBY_ENGINE}/#{RbConfig::CONFIG['ruby_version']}\"")
export GEM_HOME=$build_dir/.gem/$RUBY_VERSION
PATH="$GEM_HOME/bin:$PATH"
if test -d $build_dependencies_cache/ruby/.gem; then
  status "Restoring ruby gems directory from cache"
  cp -r $build_dependencies_cache/ruby/.gem $build_dir
  HOME=$build_dir gem update compass --user-install --no-rdoc --no-ri 2>&1 | indent
else
  HOME=$build_dir gem install compass --user-install --no-rdoc --no-ri 2>&1 | indent
fi

# Cache ruby gems
rm -rf $build_dependencies_cache/ruby
mkdir -p $build_dependencies_cache/ruby

# If app has a gems directory, cache it.
if test -d $build_dir/.gem; then
  status "Caching ruby gems directory for future builds"
  cp -r $build_dir/.gem $build_dependencies_cache/ruby
fi
