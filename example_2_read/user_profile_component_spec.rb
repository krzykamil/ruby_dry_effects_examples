# frozen_string_literal: true
RSpec.configure do |rspec|
  rspec.include Dry::Effects::Handler.Reader(:current_user), type: :component
end

RSpec.describe UserProfileComponent, type: :component do
  let(:current_user) { User.new(name: 'Dr. Brule') }
  before do
    with_current_user(current_user) { render_inline(component) }
  end

  it do
    is_expected.to have_text 'You are logged in as: Dr. Brule'
  end
end
