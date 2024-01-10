class UsersController
  def index
    users = UserService.new(UserRepository.new).call
    render json: users
  end
end

class UserService
  def initialize(user_repository)
    @user_repository = user_repository
  end

  def call
    @user_repository.get_all
  end
end

class UserRepository
  def get_all
    User.all
  end
end
