module Commontator
  class ApplicationController < ActionController::Base
    include ApplicationHelper
    before_action :set_user, :ensure_user

    rescue_from SecurityTransgression, with: -> { head(:forbidden) }

    protected

    def security_transgression_unless(check)
      raise SecurityTransgression unless check
    end

    def set_user
      begin
        @user ||= User.find(session[:current_user_id]) if session[:current_user_id]
      rescue Exception => e
        nil
      end
    end

    def ensure_user
      security_transgression_unless(@user && @user.is_commontator)
    end

    def set_thread
      @thread = params[:thread_id].blank? ? \
        Commontator::Thread.find(params[:id]) : \
        Commontator::Thread.find(params[:thread_id])
      security_transgression_unless @thread.can_be_read_by? @user
      commontator_set_new_comment(@thread, @user)
    end
  end
end
