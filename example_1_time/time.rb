# frozen_string_literal: true
require 'rubygems'
require 'bundler/setup'
require 'dry/effects'

class CurrentTimeMiddleware
  include Dry::Effects::Handler.CurrentTime

  def initialize(app)
    @app = app
  end

  def call(env)
    # It will use Time.now internally once and set it fixed
    with_current_time do
      @app.(env)
    end
  end
end

### Maybe we want to create many objects and set their start_at to exactly the same time.
# Instead of using Time.now and variable passing we can use the effect and it will be the same time for all objects.

class CreateSubscription
  include Dry::Efefcts.Resolve(:subscription_repo)
  include Dry::Effects.CurrentTime

  def call(values)
    subscription_repo.create(
      values.merge(start_at: current_time)
    )
  end
end
