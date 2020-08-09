class ChangeDefaultValueOfNullColumn < ActiveRecord::Migration[5.1]
  def change
    change_column_default :users, :null, true
  end
end
