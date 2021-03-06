# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %i[
    show edit update destroy promote invite bio
  ]
  # after_confirmation :update_to_registered


  def index
    authorize current_user
    @users_count = User.active_count
    @users = policy_scope(User).page(params[:page])
                               .per(25)
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
    authorize @user
    render 'complement'
  end

  def show
    if Setting.committees.blank?
      @committee_full_list = ''
      return nil
    end

    @committee_full_list = Setting.committees
                                  .split(',')
                                  .map(&:strip)
                                  .join(',')
  end

  def update
    authorize @user
    @user.update_status(user_params)
    if @user.update_attributes(user_params)
      redirect_to users_path, notice: I18n.t('users.updated')
    else
      render :complement, notice: I18n.t('users.not_updated')
    end
  end

  def destroy; end

  def promote
    authorize @user
    old_user = @user.dup
    old_user_committees = @user.committee_list

    user_updates = {
      role: user_params[:role],
      status: user_params[:status],
      committee_list: user_params[:committee_list]
    }
    if @user.update(user_updates)
      message = @user.inform_promoted_person(
        current_user,
        old_user,
        old_user_committees
      )
      redirect_to @user, notice: I18n.t(message, name: @user.full_name)
    else
      flash[:alert] = I18n.t('users.promoted_failed', name: @user.full_name)
      render :show
    end
  end

  def bio
    if @user.update(bio: user_params[:bio])
      redirect_to user_path(@user),
                  notice: I18n.t('users.bio_successfull')
    else
      flash[:alert] = I18n.t('users.bio_failed', name: @user.full_name)
      render :show
    end
  end

  def about_me
    my_own              = AboutMeService.new(current_user)

    @next_performance   = my_own.next_show
    @last_performance   = my_own.previous_show
    @next_course        = my_own.next_course
    @last_comments      = my_own.last_comments
    @last_poll_results  = my_own.last_poll_results
    @previous_show_date = my_own.previous_show_date
  end

  private

  def update_to_registered
    self.status = :registered
    save!
  end

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
            :bio,
            :role,
            committee_lists: []
          )
  end
end
