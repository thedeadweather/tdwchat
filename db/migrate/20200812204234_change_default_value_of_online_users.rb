class ChangeDefaultValueOfOnlineUsers < ActiveRecord::Migration[5.1]
  def change
    change_column_default :users, :online, false
  end
end
