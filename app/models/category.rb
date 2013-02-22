class Category < ActiveRecord::Base
  attr_accessible :nome, :id,:cassets_attributes

  validates :nome, :presence => true

  has_many :anuncios
  has_many :cassets, :dependent => :destroy
  accepts_nested_attributes_for :cassets
  
end
