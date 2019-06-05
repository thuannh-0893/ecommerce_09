# frozen_string_literal: true

module ApplicationHelper
  def full_title page_title
    base_title = I18n.t "helpers.base_title"
    if page_title.blank?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  def sub_categories parent_id
    @subcategories = Category.sub_categories parent_id
  end
end
