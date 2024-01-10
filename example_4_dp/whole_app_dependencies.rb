# frozen_string_literal: true
class ProviderMiddleware
  include Dry::Effects::Handler.Resolve

  def initialize(app, dependencies)
    @app = app
    @dependencies = dependencies
  end

  def call(env)
    provide(@dependencies) { @app.(env) }
  end
end

use ProviderMiddleware, user_repo: UserRepo.new
# More dependencies?
# use ProviderMiddleware2
# etc
run Application.new
