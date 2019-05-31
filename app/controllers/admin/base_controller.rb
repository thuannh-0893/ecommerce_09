class Admin::BaseController < ApplicationController
  private

  def current_ability
    @current_ability ||=
      Ability.new current_user, Settings.controller.namespace_for_admin
  end
end
