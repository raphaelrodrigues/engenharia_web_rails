class Casset < ActiveRecord::Base
  attr_accessible :category_id,:image

  belongs_to :category
  has_attached_file :image,
    :styles => {
      :thumb=> "100x100#",
      :small  => "300x200#",
      :large => "600x600#",
      :related => "220x180#"
     }	

end
