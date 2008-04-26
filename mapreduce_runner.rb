require 'rubygems'
require 'ruby2ruby'
require 'ringy_dingy'

ring_server = RingyDingy.new(nil).ring_server

loop do
  pid, block, element, idx = ring_server.take([:dmap, nil, nil, nil, nil]).last(4)
  begin
    result = eval(block).call(element)
  rescue Object => err
    result = err
  end
  puts "Got #{result} from #{element} for #{pid}."
  ring_server.write([:dmap, pid, result, idx])
end
