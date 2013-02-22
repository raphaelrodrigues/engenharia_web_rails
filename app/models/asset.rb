class Asset < ActiveRecord::Base
  attr_accessible :anuncio_id,:image

  belongs_to :anuncio
  has_attached_file :image,
    :styles => {
      :thumb=> "100x100#",
      :small  => "300x200#",
      :large => "600x600#",
      :related => "220x180#"
     }	
end
