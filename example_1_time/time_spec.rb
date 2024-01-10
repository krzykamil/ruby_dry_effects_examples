# frozen_string_literal: true
require 'dry/effects'

# Use the effect in config

RSpec.configure do |config|
  config.include Dry::Effects::Handler.CurrentTime
  config.include Dry::Effects.CurrentTime

  config.around { |example| with_current_time(&example) }
end

# Some mockup
class Subscription < Struct.new(:values)
  def closed_at
    values.dig(:closed_at)
  end

  def start_at
    values.dig(:start_at)
  end
end

def create_subscription(values)
  Subscription.new(values)
end

def close_subscription(subscription)
  Subscription.new(subscription.values.merge(closed_at: current_time))
end

# Test

RSpec.describe 'CreateSubscription' do
  let(:subscription) { create_subscription({ start_at: current_time }) }
  it 'u)ses current time as a start' do
    expect(subscription.start_at).to eql(current_time)
  end

  # Here we change the time
  it 'closes a subscription with current time' do
    future = current_time + 86_400
    closed_subscription = with_current_time(proc { future }) { close_subscription(subscription) }
    expect(closed_subscription.closed_at).to eql(future)
  end
end
