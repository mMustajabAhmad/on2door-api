class AddFieldsToDrivers < ActiveRecord::Migration[7.2]
  def up
    add_column :drivers, :first_name, :string
    add_column :drivers, :last_name, :string
    add_column :drivers, :phone_number, :string
    add_column :drivers, :capacity, :integer
    add_column :drivers, :display_name, :string
    add_column :drivers, :on_duty, :boolean
    add_column :drivers, :delay_time, :datetime
    add_column :drivers, :is_active, :boolean
    add_column :drivers, :analytics, :jsonb
    add_reference :drivers, :organization, foreign_key: true

    add_index :drivers, :phone_number, unique: true
  end

  def down
    remove_index :drivers, :phone_number
    remove_reference :drivers, :organization, foreign_key: true
    remove_column :drivers, :analytics
    remove_column :drivers, :delay_time
    remove_coumn :drivers, :is_active
    remove_column :drivers, :on_duty
    remove_column :drivers, :display_name
    remove_column :drivers, :capacity
    remove_column :drivers, :phone_number
    remove_column :drivers, :last_name
    remove_column :drivers, :first_name
  end
end
