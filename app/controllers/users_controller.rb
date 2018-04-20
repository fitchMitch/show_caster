class UsersController < ApplicationController
  def index
    # authorize current_user
    # @users = policy_scope(User).includes(:member).paginate(page: params[:page])
    @users = User.all
  end

  def create
  end

  def new
    # authorize User
    @user = User.new
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def invite
  end

  private
    def set_user
      @user = User.find(params[:id])
      # authorize @user
    end

    def user_params
      params.require(:user).permit(:firstname, :lastname, :email)
    end
end
