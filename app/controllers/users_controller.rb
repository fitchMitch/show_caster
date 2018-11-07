class UsersController < ApplicationController
  before_action :set_user, only: %i[
    show edit update destroy promote invite bio
  ]

  def index
    authorize User
    @users = policy_scope(User)
  end

  def create
    @user = User.new(user_params)
    authorize(@user)
    if @user.save
      redirect_to users_path,
                  notice: I18n.t('users.setup', full_name: @user.full_name)
    else
      render :new
    end
  end

  def new
    @user = User.new
    authorize(@user)
  end

  def edit
    target = @user.setup? ? 'edit' : 'complement'
    render target
  end

  def show; end

  def update
    phone_exists = user_params[:cell_phone_nr].blank?
    params[:user][:status] = 'registered' unless phone_exists
    if @user.update_attributes(user_params)
      redirect_to users_path, notice: I18n.t('users.updated')
    else
      render :complement, notice: I18n.t('users.not_updated')
    end
  end

  def destroy; end

  def promote
    old_user_role = @user.role
    user_updates = {
      role: params[:user][:role],
      status: params[:user][:status]
    }
    #byebug
    if @user && @user.update(user_updates)
      message = @user.inform_promoted_person(current_user, old_user_role)
      redirect_to @user, notice: I18n.t(message, name: @user.full_name)
    else
      flash[:alert] = I18n.t('users.promoted_failed', name: @user.full_name)
      render :show
    end
  end

  def invite
    if @user && @user.update(status: 'invited')
      @user.welcome_mail
      redirect_to user_path(@user), notice: I18n.t('users.invited', name: @user.full_name)
    else
      flash[:alert] = I18n.t('users.invited_failed', name: @user.full_name)
      render :show
    end
  end

  def bio
    if @user && @user.update(bio: params[:user][:bio])
      redirect_to user_path(@user),
                  notice: I18n.t('users.bio_successfull')
    else
      flash[:alert] = I18n.t('users.bio_failed', name: @user.full_name)
      render :show
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
    authorize(@user)
  end

  def user_params
    params.require(:user)
          .permit(
            :firstname,
            :lastname,
            :email,
            :address,
            :cell_phone_nr,
            :status,
            :bio
          )
  end
end
