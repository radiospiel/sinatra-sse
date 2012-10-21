# This file is part of the sinatra-sse ruby gem.
#
# Copyright (c) 2011, 2012 @radiospiel
# Distributed under the terms of the modified BSD license, see LICENSE.BSD

$:.unshift File.expand_path("../lib", __FILE__)

require "bundler/setup"

Dir[File.expand_path("../tasks/*.rake", __FILE__)].each do |task|
  load task
end

# Add "rake release and rake install"
Bundler::GemHelper.install_tasks

task :default => [:test, :rdoc]
