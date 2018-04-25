class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]

  def index
    authorize User
    @users = User.all
  end

  def create
    @user = User.new(user_params)
    authorize(@user)
    if @user.save
      redirect_to users_path, notice: I18n.t("users.setup", full_name: @user.full_name)
    else
      render :new
    end
  end

  def new
    @user = User.new
    authorize(@user)
  end

  def edit
    authorize(@user)
    target = @user.setup? ? "edit" : "complement"
    render target.to_s
  end

  def show
    authorize(@user)
  end

  def update
    authorize(@user)
    params[:user][:status] = "registered" unless user_params[:cell_phone_nr].blank?
    if @user.update_attributes(user_params)
      redirect_to users_path, notice: I18n.t("users.updated")
    else
      render :edit, notice: I18n.t("users.not_updated")
    end
  end

  def destroy
    authorize(@user)
  end

  def promote
    @user = User.find(params[:user][:id])
    return if @user.nil?

    @user.status = params[:user][:status]
    @user.role = params[:user][:role]
    if @user.save
      inform_promoted_person(@user)
      redirect_to users_path, notice: I18n.t('users.promoted', name: @user.full_name)
    else
      flash[:alert] = I18n.t('users.promoted_failed', name: @user.full_name)
      render 'users/show'
    end
  end

  private
    def inform_promoted_person(user)
      role = user.role
      excl_1 = Rails.env.downcase == 'development'
      excl_2 = current_user == user
      excl_3 = role == 'player'
      # TODO user.promoted_mail(role) unless  excl_1 || excl_2 || excl_3
      # user.promoted_mail(role) unless  excl_2 || excl_3
    end

    def set_user
      @user = User.find(params[:id])
      # authorize @user
    end

    def user_params
      params.require(:user).permit(:firstname, :lastname, :email, :address, :cell_phone_nr, :status)
    end
end
