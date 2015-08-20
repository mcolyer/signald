class BaseSignal
  def send_signal(name, bool)
    queue_name = ENV["SIGNALD_QUEUE"] || "/signald"
    POSIX_MQ.open(queue_name, :w) do |queue|
      queue.nonblock = true
      begin
        queue.send ::JSON.generate(id: name, value: bool)
      rescue Errno::EAGAIN
        $stderr.puts "Queue was full"
      end
    end
  end
end
