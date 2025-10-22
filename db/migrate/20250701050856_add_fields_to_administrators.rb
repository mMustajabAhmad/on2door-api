class AddFieldsToAdministrators < ActiveRecord::Migration[7.2]
  def up
    add_column :administrators, :first_name, :string
    add_column :administrators, :last_name, :string
    add_column :administrators, :role, :integer
    add_column :administrators, :phone_number, :string
    add_column :administrators, :is_active, :boolean
    add_column :administrators, :is_read_only, :boolean
    add_column :administrators, :is_account_owner, :boolean
    add_reference :administrators, :organization, foreign_key: true
  end

  def down
    remove_column :administrators, :first_name
    remove_column :administrators, :last_name
    remove_column :administrators, :role
    remove_column :administrators, :phone_number
    remove_column :administrators, :is_active
    remove_column :administrators, :is_read_only
    remove_column :administrators, :is_account_owner
    remove_reference :administrators, :organization
  end
end
