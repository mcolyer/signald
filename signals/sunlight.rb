require './signals/base'
require 'solareventcalculator'

class SunlightSignal < BaseSignal
  def initialize(name, config)
    @name = name
    @config = config
    $0 = "signald: #{@name}"
  end

  def watch
    prev_state = nil
    state = nil

    while true do
      date = Date.today
      calc = SolarEventCalculator.new(date, BigDecimal.new("37.482778"), BigDecimal.new("-122.236111"))
      sunrise = calc.compute_official_sunrise("America/Los_Angeles")
      sunset = calc.compute_official_sunset("America/Los_Angeles")
      now = DateTime.now

      if now > sunrise && now < sunset
        state = true
      elsif state != false
        state = false
      end

      if prev_state != state
        send_signal(@name, state)
        prev_state = state
      end

      sleep 60
    end
  end
end
