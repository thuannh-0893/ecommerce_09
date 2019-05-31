class OrderMailer < ApplicationMailer
  def order_complete user, order
    @user = user
    @order = order
    mail to: user.email
  end
end
