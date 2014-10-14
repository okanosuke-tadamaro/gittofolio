class Screenshot < ActiveRecord::Base
  belongs_to :repository

  has_attached_file :image, :styles => { :small => '640x480>', :medium => '1280x800>', :large => '1920x1080>' }
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
end
