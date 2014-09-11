# This file is part of the sinatra-sse ruby gem.
#
# Copyright (c) 2011, 2012 @radiospiel
# Distributed under the terms of the modified BSD license, see LICENSE.BSD

module Sinatra::SSE
end

require_relative "sse/version"
require_relative "sse/marshal"

# Support for SSE streams.
#
# The Sinatra::SSE module adds support for streaming server sent events.
#
# It wraps a sinatra stream (via <tt>stream :keep_open</tt>) in a structure
# which
#
# - formats events according to the SSE specs, and
# - keeps the connection alive by sending some data every 28 seconds.
#
module Sinatra::SSE
  extend Marshal
  
  # The keepalive period.
  KEEP_ALIVE = 28

  # The SSEStream class wraps a connection as created via the Sinatra
  # stream helper.
  class Stream #:nodoc:
    def initialize(out)
      @out = out

      @out.callback do
        cancel_keepalive_timer
        @callback.call if @callback
      end

      @out.errback do
        @errback.call if @errback
      end

      reset_keepalive_timer
    end
    
    def close
      @out.close
    end
    
    # set a callback block for errors
    def errback(&block)
      @errback = Proc.new
    end
    
    # set a callback block.
    def callback(&block)
      @callback = Proc.new
    end
    
    # Push an event to the client.
    def push(hash)
      raise ArgumentError unless hash.is_a?(Hash)
      
      @out << Sinatra::SSE.marshal(hash)
      reset_keepalive_timer
    end
    
    private
    
    def cancel_keepalive_timer #:nodoc:
      @timer.cancel if @timer
    end

    def reset_keepalive_timer #:nodoc:
      cancel_keepalive_timer
      @timer = EventMachine::PeriodicTimer.new(KEEP_ALIVE) { send_keepalive_traffic }
    end
    
    def send_keepalive_traffic #:nodoc:
      @out << " \n"
    end
  end

  # Start a SSE stream.
  def sse_stream(&block)
    content_type "text/event-stream"

    stream :keep_open do |out|
      yield Sinatra::SSE::Stream.new(out)
    end
  end
end
