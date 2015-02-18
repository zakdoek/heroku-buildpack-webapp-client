#!/usr/bin/env bash

current_dir_cache=$PWD

# Install bower dependencies
if [ -e $build_dir/bower.json ]; then
  status "Install bower dependencies"
  if test -d $build_dependencies_cache/bower; then
    status "Restoring bower components from cache"
    cp -r $build_dependencies_cache/bower $build_dir/bower_components

    cd $build_dir
    HOME=$build_dir $build_dir/node_modules/.bin/bower install 2>&1 | indent
    cd $current_dir_cache

  else

    cd $build_dir
    HOME=$build_dir $build_dir/node_modules/.bin/bower install  2>&1 | indent
    cd $current_dir_cache

  fi

  # Cache bower
  rm -rf $build_dependencies_cache/bower
  # If app has a bower directory, cache it.
  if test -d $build_dir/bower_components; then
    status "Caching bower cache directory for future builds"
    cp -r $build_dir/bower_components $build_dependencies_cache/bower
  fi
fi
