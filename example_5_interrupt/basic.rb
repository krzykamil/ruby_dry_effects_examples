# frozen_string_literal: true
require 'dry/effects'

class LoginManager
  include Dry::Effects::Handler.Interrupt(:invalid_credentials, as: :catch_invalid_credentials)

  def call
    error, message = catch_invalid_credentials do
      yield
    end

    error ? :error : message
  end
end

class Authenticate
  include Dry::Effects.Interrupt(:invalid_credentials)

  def call(email, password)
    (email == 'ksysio@mail.com' && password == 'secure') ? "Logged in, welcome!" : invalid_credentials
  end
end

run = LoginManager.new
auth = Authenticate.new


# Mocks up a situation, where inside an app, we want to log the user in
app = -> email, pass do
  run.() do
    auth.(email, pass)
  end
end

puts app.('ksysio@mail.com', 'secure')
puts app.('sarin@to.boss', 'secure')

