# This file is part of the sinatra-sse ruby gem.
#
# Copyright (c) 2011, 2012 @radiospiel
# Distributed under the terms of the modified BSD license, see LICENSE.BSD

$:.unshift File.expand_path("../lib", __FILE__)
require "sinatra/sse/version"

Gem::Specification.new do |gem|
  gem.name     = "sinatra-sse"
  gem.version  = Sinatra::SSE::VERSION

  gem.author   = "radiospiel"
  gem.email    = "eno@radiospiel.org"
  gem.homepage = "http://github.com/radiospiel/sinatra-sse"
  gem.summary  = "Sinatra support for server sent events"

  gem.add_dependency "expectation"
  gem.add_dependency "sinatra"
  
  gem.description = gem.summary

  gem.files = Dir["**/*"].select { |d| d =~ %r{^(README|bin/|data/|ext/|lib/|spec/|test/)} }
end
