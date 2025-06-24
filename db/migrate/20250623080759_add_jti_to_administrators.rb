class AddJtiToAdministrators < ActiveRecord::Migration[7.1]
  def change
    add_column :administrators, :jti, :string
    add_index :administrators, :jti
  end
end
