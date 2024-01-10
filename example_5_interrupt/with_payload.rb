# frozen_string_literal: true
require 'dry/effects'

class TemperatureSensor
  include Dry::Effects.Interrupt(:location_error)

  def read_temperature(location)
    if location == 'Warszawa'
      25.0
    elsif location == 'Białystok'
      10.0
    else
      location_error "Invalid location, but the closest location we know of, has temperature: 666.69"
    end
  end
end

class WeatherReporter
  include Dry::Effects::Handler.Interrupt(:location_error, as: :catch_location_error)
  def report_weather(location)
    _, result = catch_location_error do
      "Temperature at #{location} is: #{yield}"
    end

    result
  end
end

report_system = WeatherReporter.new
temperature_monitoring_system = TemperatureSensor.new

puts report_system.report_weather("Białystok") { temperature_monitoring_system.read_temperature("Białystok") }
puts report_system.report_weather("Warszawa") { temperature_monitoring_system.read_temperature("Warszawa") }
puts report_system.report_weather("hell") { temperature_monitoring_system.read_temperature("hell") }
