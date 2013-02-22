class CreateAnuncios < ActiveRecord::Migration
  def change
    create_table :anuncios do |t|
      t.string :nome
      t.text :descricao
      t.decimal :preco
      t.date :dataSubmissao
      t.integer :activo
      t.string :tipo
      t.boolean :destaque
      t.integer :user_id

      t.timestamps
    end
  end
end
