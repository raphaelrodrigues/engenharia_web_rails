class Anuncio < ActiveRecord::Base
  attr_accessible :activo, :dataSubmissao, :descricao, :destaque, :nome, :preco, :tipo, :user_id, :category_id ,:assets_attributes

  validates :user_id, :presence => true
  validates :category_id, :presence => true
  validates :nome,:descricao,:tipo, :presence => true
  
  belongs_to :user
  belongs_to :category

  has_many :assets, :dependent => :destroy
  accepts_nested_attributes_for :assets

  #procura por nome
  def self.search(nome,tipo,category_id)
	   if nome
      where('(nome LIKE ? or descricao LIKE ?) and tipo LIKE ? and activo == 1',"%#{nome}%","%#{nome}%","%#{tipo}%")
     elsif !category_id.nil?
      where('category_id = ? and activo == 1',category_id)
      else
       where('tipo LIKE ? and activo == 1',"%#{tipo}%")
    end
  end

  #devolve anuncios desactivos
  def self.desactivos
    find(:all,:conditions => ['activo == 0'])
  end
  

  #procura avançada
  def self.advanced_search(nome,category_id,tipo,minimum_price,maximum_price)

    anuncios = limit(1000)
    anuncios = anuncios.where('nome LIKE ? or descricao LIKE ?',"%#{nome}%","%#{nome}%") unless nome.nil? || nome.blank?
    anuncios = anuncios.where("preco >= ? ",minimum_price) unless  minimum_price.blank? ||  minimum_price.nil?
    anuncios = anuncios.where("preco < ? ",maximum_price) unless maximum_price.nil? || maximum_price.blank?

    
    if category_id != "Todas as categorias"
          anuncios = anuncios.where("category_id = ?",category_id)
    end


    case tipo
      when "Compra"
        anuncios = anuncios.where("tipo LIKE ?","%Compra%")
      when "Todos os tipos"
        anuncios = anuncios.where("tipo LIKE ?","%%")
      when "Venda"
        anuncios = anuncios.where("tipo LIKE ?","%Venda%")
      when "Troca"
         anuncios = anuncios.where("tipo LIKE ?","%Troca%")
    end


    anuncios

  end



  
end
