class BaseSignal
  def send_signal(bool)
    POSIX_MQ.open("/signald", :w) do |queue|
      queue.nonblock = true
      begin
        queue.send ::JSON.generate(id: @name, value: bool)
      rescue Errno::EAGAIN
        $stderr.puts "Queue was full"
      end
    end
  end
end
