class Category < ApplicationRecord
  has_many :products, dependent: :destroy
  has_many :child_categories, class_name: Category.name,
    foreign_key: "parent_id"
end
