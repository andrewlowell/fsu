class Image < ActiveRecord::Base
  has_attached_file :data, :styles => { :large => "750x750>", :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :data, :content_type => /\Aimage\/.*\Z/
end
