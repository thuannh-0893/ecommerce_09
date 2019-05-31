module Admin::OrdersHelper
  def css_with_status order
    case order.status
    when "pending"
      "info"
    when "processing"
      "warning"
    when "completed"
      "success"
    when "canceled"
      "danger"
    end
  end
end
