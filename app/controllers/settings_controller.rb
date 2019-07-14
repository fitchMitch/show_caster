# frozen_string_literal: true

class SettingsController < ApplicationController
  before_action :get_setting, only: %i[edit update]

  def index
    @settings = Setting.get_all
  end

  def edit; end

  def update
    if @setting.value != params[:setting][:value]
      @setting.value = params[:setting][:value]
      @setting.save
      redirect_to settings_path, notice: I18n.t('settings.created_ok')
    else
      redirect_to settings_path, notice: I18n.t('settings.created_nok')
    end
  end

  def get_setting
    @setting = Setting.find_by(var: params[:id]) ||
               Setting.new(var: params[:id])
  end
end
