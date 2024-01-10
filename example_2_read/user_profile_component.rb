# frozen_string_literal: true
class UserProfileComponent < ViewComponent::Base
  include Dry::Effects.Reader(:current_user, default: nil)

  def logged_in_user_name
    'You are logged in as: ' + current_user.name
  end
end
