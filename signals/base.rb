class BaseSignal
  def send_signal(bool)
    queue = POSIX::Mqueue.new("/signald")
    begin
      queue.timedsend "id=#{@name} value=#{bool}"
    rescue POSIX::Mqueue::QueueFull
      $stderr.puts "Queue was full"
    end
  end
end
