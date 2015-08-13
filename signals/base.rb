class BaseSignal
  def send_signal(bool)
    queue = POSIX_MQ.new("/signald", :w)
    queue.nonblock = true
    begin
      queue.send "id=#{@name} value=#{bool}"
    rescue Errno::EAGAIN
      $stderr.puts "Queue was full"
    end
  end
end
