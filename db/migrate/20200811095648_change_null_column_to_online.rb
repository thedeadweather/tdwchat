class ChangeNullColumnToOnline < ActiveRecord::Migration[5.1]
  def change
    rename_column :users, :null, :online
  end
end
