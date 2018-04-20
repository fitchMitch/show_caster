class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    # authorize current_user
    # @users = policy_scope(User).includes(:member).paginate(page: params[:page])
    @users = User.all
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to users_path, notice: I18n.t("users.set_up", full_name: @user.full_name)
    else
      render :new
    end
  end

  def new
    # authorize User
    @user = User.new
  end

  def edit
  end

  def show
  end

  def update
    if @user.update_attributes(user_params)
      redirect_to users_path, notice: I18n.t("users.updated")
    else
      render :edit, notice: I18n.t("users.not_updated")
    end
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
      params.require(:user).permit(:firstname, :lastname, :email, :address, :cell_phone_nr)
    end
end
