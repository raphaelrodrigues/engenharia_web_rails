class CreateCassets < ActiveRecord::Migration
  def change
    create_table :cassets do |t|
      t.integer :category_id

      t.timestamps
    end
  end
end
