# This file is part of the sinatra-sse ruby gem.
#
# Copyright (c) 2011, 2012 @radiospiel
# Distributed under the terms of the modified BSD license, see LICENSE.BSD

$:.unshift File.expand_path("../lib", __FILE__)

require 'rdoc/task'

RDoc::Task.new do |rdoc|
  require "sinatra/sse/version"
  version = Sinatra::SSE::VERSION

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "expectation #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
