# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Dry::Effects::Handler.Reader(:current_user)
  # Using a callback, so a side effect, alongside AE, cause it can be done easily
  around_action :set_current_user

  private

  def set_current_user
    @current_user = User.find(session[:user_id])
    # with_current_user is provided by the Dry::Effects::Handler.Reader(:current_user)
    with_current_user(@current_user) { yield }
  end
end
