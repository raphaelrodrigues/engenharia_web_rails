class Anuncio < ActiveRecord::Base
  attr_accessible :activo, :dataSubmissao, :descricao, :destaque, :nome, :preco, :tipo, :user_id, :category_id ,:assets_attributes

  validates :user_id, :presence => true
  validates :category_id, :presence => true
  validates :nome,:descricao,:tipo, :presence => true
  
  belongs_to :user
  belongs_to :category

  has_many :assets, :dependent => :destroy
  accepts_nested_attributes_for :assets

  def self.search(nome,tipo,category_id)
	   if nome
      where('(nome LIKE ? or descricao LIKE ?) and tipo LIKE ? and activo == 1',"%#{nome}%","%#{nome}%","%#{tipo}%")
     elsif !category_id.nil?
      where('category_id = ? and activo == 1',category_id)
      else
       where('tipo LIKE ? and activo == 1',"%#{tipo}%")
    end
  end

  def self.desactivos
    find(:all,:conditions => ['activo == 0'])
  end
  
  def self.advanced_search(nome,minimum_price,maximum_price,category_id,tipo)

    anuncios = limit(1000)
    anuncios = anuncios.where('nome LIKE ? or descricao LIKE ?',"%#{nome}%","%#{nome}%") unless nome.nil? || nome.blank?
    anuncios = anuncios.where("preco >= ? ",minimum_price) unless  minimum_price.blank? ||  minimum_price.nil?
    anuncios = anuncios.where("preco < ? ",maximum_price) unless maximum_price.nil? || maximum_price.blank?


     if category_id != 0
       anuncios = anuncios.where("category_id = ?",category_id)
     end
    

    if tipo == 1
      anuncios = anuncios.where("tipo LIKE ?","%Compra%")
    elsif tipo == 2
      anuncios = anuncios.where("tipo LIKE ?","%Venda%")
    elsif tipo == 3
      anuncios = anuncios.where("tipo LIKE ?","%Troca%")
    else
      anuncios = anuncios.where("tipo LIKE ?","%%")
    end

    anuncios
  end



  
end
