class AddUniqueIndexToAdministratorsPhoneNumber < ActiveRecord::Migration[7.2]
  def up
    add_index :administrators, :phone_number, unique: true
  end

  def down
    remove_index :administrators, :phone_number
  end
end
