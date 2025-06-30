class AddEmailToClient < ActiveRecord::Migration[7.2]
  def change
    add_column :clients, :email, :string
  end
end
