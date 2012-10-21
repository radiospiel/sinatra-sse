# This file is part of the sinatra-sse ruby gem.
#
# Copyright (c) 2011, 2012 @radiospiel
# Distributed under the terms of the modified BSD license, see LICENSE.BSD

Dir.chdir File.dirname(__FILE__)

require "bundler/setup"
require "rack"

require "sinatra/base"
require "sinatra/sse"

class TimeServer < Sinatra::Base
  include Sinatra::SSE
  
  get '/' do
    sse_stream do |out|
      EM.add_periodic_timer(1) do 
        out.push :event => "timer", :data => Time.now.to_s
      end
    end
  end
end

use Rack::CommonLogger
run TimeServer.new


# Note: run
#
#   curl -s -H "Accept: text/event-stream" url
#
# to see the stream of SSE events.