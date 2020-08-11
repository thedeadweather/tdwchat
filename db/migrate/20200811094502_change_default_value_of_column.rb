class ChangeDefaultValueOfColumn < ActiveRecord::Migration[5.1]
  def change
    change_column_default :users, :null, true
    change_column_null :users, :null, false
  end
end
