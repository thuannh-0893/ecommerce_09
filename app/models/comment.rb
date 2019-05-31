class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :product
  has_many :child_comments, dependent: :destroy,
    class_name: Comment.name, foreign_key: :parent_id

  scope :product_comments, ->(id){where product_id: id}
  scope :product_comments_parrent, ->(id){where product_id: id, parent_id: nil}
  scope :by_date, ->{order(updated_at: :desc)}
  scope :sub_comments, ->(parent_id){where parent_id: parent_id}
end
