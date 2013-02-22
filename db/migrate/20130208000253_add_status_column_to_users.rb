class AddStatusColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :status, :string ,:limit => 1,:null => false, :default => 'R'
  end
end
