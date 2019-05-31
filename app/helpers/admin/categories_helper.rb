module Admin::CategoriesHelper
  def find_parent parent_id
    @categories.find_by id: parent_id
  end
end
