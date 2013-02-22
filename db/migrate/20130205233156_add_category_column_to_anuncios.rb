class AddCategoryColumnToAnuncios < ActiveRecord::Migration
  def change
    add_column :anuncios, :category_id, :integer
  end
end
