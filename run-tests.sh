#!/usr/bin/env bash

set -e

BUNDLE_GEMFILE=spec/dummy_apps/rails-7.1/Gemfile TEST_VERSION=7.1 bundle exec rake
BUNDLE_GEMFILE=spec/dummy_apps/rails-8.0/Gemfile TEST_VERSION=8.0 bundle exec rake
