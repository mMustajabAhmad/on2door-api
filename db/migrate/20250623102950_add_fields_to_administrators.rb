class AddFieldsToAdministrators < ActiveRecord::Migration[7.1]
  def change
    add_column :administrators, :name, :string
    add_column :administrators, :role, :integer 
    add_column :administrators, :phone_number, :string
    add_column :administrators, :is_active, :boolean
    add_column :administrators, :is_read_only, :boolean
    add_column :administrators, :is_account_owner, :boolean
    add_reference :administrators, :organization, foreign_key: true
  end
end
