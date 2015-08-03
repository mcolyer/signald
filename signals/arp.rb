class ArpSignal
  def initialize(name, config)
    @name = name
    @config = config
  end

  def send_signal(bool)
    queue = POSIX::Mqueue.new("/signald")
    begin
      queue.timedsend "id=#{@name} value=#{bool}"
    rescue POSIX::Mqueue::QueueFull
      $stderr.puts "Queue was full"
    end
  end

  def watch
    mac_address = @config["mac_address"]
    sleep_period = @config["sleep_period"]
    maximum_wait_for_signal = @config["maximum_cycles_to_wait"]
    
    state = :absent
    count = 0
    
    while true do
      date = DateTime.now
      date_stamp = date.strftime("%h %d %H:%M:%S")
      #puts "#{date_stamp} count=#{count} state=#{state}"

      present = system("arping", "-i", "eth0", "-qc", "1", mac_address)
    
      if state == :absent && present
        count = 0
        state = :present
        send_signal(true)
      elsif state == :present && !present && count > maximum_wait_for_signal
        state = :absent
        send_signal(false)
      elsif present
        count = 0
      elsif !present
        count += 1
      end
    
      sleep sleep_period
    end
  end
end
