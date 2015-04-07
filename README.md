# sinatra-sse

Sinatra support for server-sent events. The sinatra-sse gem needs a web server, which
supports async operation. It is tested with thin.
 
## Installation

    gem install sinatra-sse

## Getting started: the timer example

The timer example (in example/config.ru) sends time information over an SSE stream, like this:

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

## Run the example

The SSE specs define the "text/event-stream" content type. Conforming clients 
send these in the "Accept:" header, and conforming servers set the "Content-Type:"
header accordingly.

    1.9.2 ~/sinatra-sse/lib[master] > curl -s -H "Accept: text/event-stream" http://0.0.0.0:9292
    event: timer
    data: 2012-10-21 11:21:48 +0200

    event: timer
    data: 2012-10-21 11:21:49 +0200

## License

The sinatra-sse gem is (c) radiospiel, 2012; it is distributed under the terms of the Modified BSD License, see LICENSE.BSD for details.
