class AddEmailToRecipients < ActiveRecord::Migration[6.1]
  def up
    add_column :recipients, :email, :string
    add_index :recipients, :email
  end

  def down
    remove_index :recipients, :email
    remove_column :recipients, :email
  end
end
