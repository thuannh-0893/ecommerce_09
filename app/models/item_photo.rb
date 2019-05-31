class ItemPhoto < ApplicationRecord
  mount_uploader :photo, PictureUploader
  belongs_to :product
end
