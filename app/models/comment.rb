class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :product
  has_many :child_comments, class_name: Comment.name, foreign_key: :parent_id
end
