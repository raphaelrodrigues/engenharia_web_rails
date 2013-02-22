class AddDashboardToUser < ActiveRecord::Migration
  def change
    add_column :users, :dashboard, :string,:limit => 1,:null => false, :default => 'N'
  end
end
