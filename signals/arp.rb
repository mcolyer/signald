require './signals/base'

class ArpSignal < BaseSignal
  def initialize(name, config)
    @name = name
    @config = config
    $0 = "signald: #{@name}"
  end

  def watch
    mac_address = @config["mac_address"]
    sleep_period = @config["sleep_period"]
    maximum_wait_for_signal = @config["maximum_cycles_to_wait"]
    
    state = :absent
    count = 0
    
    while true do
      present = system("arping", "-i", "eth0", "-qc", "1", mac_address)
    
      if state == :absent && present
        count = 0
        state = :present
        send_signal(@name, true)
      elsif state == :present && !present && count > maximum_wait_for_signal
        state = :absent
        send_signal(@name, false)
      elsif present
        count = 0
      elsif !present
        count += 1
      end
    
      sleep sleep_period
    end
  end
end
