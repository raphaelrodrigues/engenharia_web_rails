class AddPaperclipToCassets < ActiveRecord::Migration
  def change
    add_column :cassets, :image_file_name, :string
  end
end
