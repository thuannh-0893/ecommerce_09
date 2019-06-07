class Category < ApplicationRecord
  has_many :products, dependent: :destroy
  has_many :child_categories, class_name: Category.name,
    foreign_key: :parent_id, dependent: :destroy

  validates :name, presence: true,
    length: {
      maximum: Settings.category.max_length,
      minimum: Settings.category.min_length
    },
    uniqueness: {case_sensitive: false}

  before_validation :to_slug

  scope :by_name, ->{order(name: :asc)}
  scope :parent_only, ->{where parent_id: nil}
  scope :sub_categories, ->(parent_id){where parent_id: parent_id}
  scope :sub_only, ->{where "parent_id != ''"}

  private

  def to_slug
    # strip the string
    ret = name.strip

    # blow away apostrophes
    ret.gsub!(/['`]/, "")

    # @ --> at, and & --> and
    ret.gsub!(/\s*@\s*/, " at ")
    ret.gsub!(/\s*&\s*/, " and ")

    # replace all non alphanumeric, underscore or periods with underscore
    ret.gsub!(/\s*[^A-Za-z0-9\.\-]\s*/, "_")

    # convert double underscores to single
    ret.gsub!(/_+/, "_")

    # strip off leading/trailing underscore
    ret.gsub!(/\A[_\.]+|[_\.]+\z/, "")

    ret
  end
end
