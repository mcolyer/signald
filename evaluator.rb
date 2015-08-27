class Evaluator
  def initialize(config)
    @actions = config["actions"] 
    @signals = Hash.new(true)
    @state = {}

    signals = config["signals"] || {}
    signals.each_pair do |name, attrs|
      @signals[name] = !!attrs["initial_state"] if attrs.has_key? "initial_state"
    end
  end

  def evaluate(message)
    data = JSON.parse(message)
    @signals[data["id"]] = data["value"]
    puts "#{Time.now} #{data.inspect}"

    @actions.each do |name, attrs|
      new_state = eval(attrs["eval"])
      if new_state != @state[name]
        if new_state
          puts "#{name}: Executing activation commands"
          (attrs["activated"] || []).each do |command|
            system({"RUBYOPT" => nil, "GEM_HOME" => nil, "GEM_PATH" => nil, "BUNDLE_BIN_PATH" => nil, "BUNDLE_GEMFILE" => nil}, command)
          end
        else
          puts "#{name}: Executing deactivation commands"
          (attrs["deactivated"] || []).each do |command|
            system({"RUBYOPT" => nil, "GEM_HOME" => nil, "GEM_PATH" => nil, "BUNDLE_BIN_PATH" => nil, "BUNDLE_GEMFILE" => nil}, command)
          end
        end
        @state[name] = new_state
      end
    end
  end
end
