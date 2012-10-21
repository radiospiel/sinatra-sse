# This file is part of the sinatra-sse ruby gem.
#
# Copyright (c) 2011, 2012 @radiospiel
# Distributed under the terms of the modified BSD license, see LICENSE.BSD

require "expectation"

#
# packing/unpacking SSE events
module Sinatra::SSE::Marshal
  FIXED_ORDER = {
    :event  => 1,
    :id     => 2,
    :data   => 3
  } #:nodoc:

  # converts an object into an event.
  #
  # The object must be a hash or a String.
  def marshal(object)
    expect! object => [ String, Hash ]
    
    if object.is_a?(String)
      object = { :data => object }
    end
    
    # sort all entries in a way, that make sure that event, id, data
    # are at the end. This makes sure that confirming clients just
    # ignore the extra entries. If we would just send them in random
    # order we might produce "bogus" events, when "data", "event",
    # and "id" are separated by invalid entries. 
    entries = object.sort_by { |key, value| FIXED_ORDER[key.to_sym] || 0 }

    entries.map do |key, value|
      escaped_value = value.gsub(/(\r\n|\r|\n)/, "\n#{key}: ")
      "#{key}: #{escaped_value}\n"
    end.join + "\n"
  end

  # Unmarshals a single event in data. The string SHOULD NOT contain 
  # multipe events, or else the returned hash somehow mangles all these
  # events into a single one.
  def unmarshal(data)
    event = Hash.new { |hash, key| hash[key] = [] }

    data.split("\n").each do |line|
      key, value = line.split(/: ?/, 2)
      next if key =~ /^\s*$/

      event[key.to_sym] << value
    end

    event.inject({}) do |hash, (key, value)|
      hash.update key => value.join("\n")
    end
  end

  # Extract all events from a data stream.
  def unmarshal_all(data)
    data.split(/\n\n/).
      map { |event| unpack(event) }.
      reject(&:empty?)
  end
end
