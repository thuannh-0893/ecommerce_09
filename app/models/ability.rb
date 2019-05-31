class Ability
  include CanCan::Ability

  def initialize current_user, controller_namespace
    can %i(new create), User
    return if current_user.blank?
    case controller_namespace
    when Settings.controller.namespace_for_admin
      can :manage, :all if current_user.admin?
    else
      authorize_to_user
    end
  end

  private

  def authorize_to_user
    can %i(index show edit update), User
    can :create, Order
    can :destroy, ItemPhoto
    can :manage, HistoryOrdersController
    can :manage, RequestsController
  end
end
