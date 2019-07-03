class Ability
  include CanCan::Ability

  def initialize current_user, controller_namespace
    can %i(new create), User
    return if current_user.blank?
    case controller_namespace
    when Settings.controller.namespace_for_admin
      can :manage, :all if current_user.admin?
    else
      authorize_to_user current_user
    end
  end

  private

  def authorize_to_user current_user
    if current_user.customer?
      can :show, User, id: current_user.id
      can %i(create show), Order, user_id: current_user.id
      can :destroy, ItemPhoto
      can :manage, HistoryOrdersController
      can :manage, RequestsController
    else
      can :manage, :all
    end
  end
end
