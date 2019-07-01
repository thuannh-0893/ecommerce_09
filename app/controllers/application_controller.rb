# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include CartHelper

  rescue_from CanCan::AccessDenied do
    if logged_in?
      flash[:danger] = t "helpers.warning[not_authorized]"
      redirect_to root_path
    else
      flash[:danger] = t "helpers.warning[login_cancan]"
      redirect_to login_url
    end
  end

  protect_from_forgery with: :exception
  include SessionsHelper
  before_action :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def configure_permitted_parameters
    added_attrs = [:name, :email, :password, :password_confirmation,
      :phone, :address, :avatar, :remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def correct_user
    find_user
    return if current_user?(@user) || current_user.admin?
    flash[:danger] = t "helpers.error[not_correct_user]"
    redirect_to root_url
  end

  def admin_user
    return if current_user.admin?
    flash[:danger] = t "helpers.error[not_admin]"
    redirect_to root_url
  end

  def load_categories
    @categories = Category.by_name
  end

  def current_ability
    @current_ability ||= Ability.new(current_user, "")
  end
end
