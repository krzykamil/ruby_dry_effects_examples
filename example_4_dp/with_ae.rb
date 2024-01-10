# frozen_string_literal: true
class UserService
  include Dry::Effects.Resolve(:user_repo)
  def call
    user_repo.get_all
  end
end

class UsersController
  include Dry::Effects::Handler.Resolve
  def index
    provide(user_repo: UserRepository.new) do
      users = UserService.new.call
      render json: users
    end
  end
end

class Add
  include Dry::Effects::State(:result)

  def call(x)
    self.result += x
    nil
  end
end

class Subtract
  include Dry::Effects::State(:result)

  def call(x)
    self.result -= x
    nil
  end
end

class Calc
  include Dry::Effects::Handler.State(:result)

  def add
    Add.new
  end

  def subtract
    Subtract.new
  end

  def call(x, y, z)
    with_result(x) do
      add.(y)
      subtract.(z)
      "Done"
    end
  end


end

calc = Calc.new
calc.(42, 12, 4) #=> 42 + 12 - 4 = 50
# => [50,  "Done"]

class MyThing
  include Dry::Effects.Cmp(:feature_flag)
  include Dry::Effects.State(:result)

  def call()
    if feature_flag
      self.result += 7
      "Branch 1"
    else
      self.result += 1
      "Branch 2"
    end
  end
end


work = MyThing.new

Dry::Effects[:cmp, :feature_flag].() do
  Dry::Effects[:state, :result].(42) do
    work.()
  end
end
# => [[43, "Branch 2"], [49, "Branch 1"]]
