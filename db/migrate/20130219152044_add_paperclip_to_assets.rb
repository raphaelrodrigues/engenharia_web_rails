class AddPaperclipToAssets < ActiveRecord::Migration
  def change
    add_column :assets, :image_file_name, :string
  end
end
