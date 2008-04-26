require 'rubygems'
require 'ringy_dingy'
require 'ruby2ruby'

module Enumerable
  def dmap(&block)
    each_with_index do |element,idx|
      ring_server.write([:dmap, Process.pid, block.to_ruby, element, idx])
    end

    results = []
    while results.size < size
      result, idx = ring_server.take([:dmap, Process.pid, nil, nil]).last(2)
      results[idx] = result
    end

    results
  end

  def ring_server
    @ring_server ||= RingyDingy.new(nil).ring_server
  end
end
