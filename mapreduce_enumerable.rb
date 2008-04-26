require 'rubygems'
require 'ringy_dingy'
require 'ruby2ruby'

module Enumerable
  def dmap(&block)
    self.each_with_index do |element,idx|
      ring_server.write([:dmap, Process.pid, block.to_ruby, element, idx])
    end

    results = []
    while results.size < self.size
      result, idx = ring_server.take([:dmap, Process.pid, nil, nil]).last(2)
      results[idx] = result
    end

    results
  end

  def ring_server
    return @ring_server if @ring_server

    ringy_dingy = RingyDingy.new nil
    @ring_server = ringy_dingy.ring_server
  end
end
