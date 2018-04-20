class UsersController < ApplicationController
  def index
    # authorize current_user
    # @users = policy_scope(User).includes(:member).paginate(page: params[:page])
    @users = User.all
  end

  def create
  end

  def new
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def invite
  end
end
