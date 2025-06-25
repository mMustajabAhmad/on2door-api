class AddFieldsToDrivers < ActiveRecord::Migration[7.1]
  def change
    add_column :drivers, :name, :string
    add_column :drivers, :phone_number, :string
    add_column :drivers, :capacity, :integer
    add_column :drivers, :display_name, :string
    add_column :drivers, :string, :string
    add_column :drivers, :on_duty, :boolean
    add_column :drivers, :delay_time, :datetime
    add_column :drivers, :analytics, :jsonb
    add_reference :drivers, :organization, foreign_key: true

    add_index :drivers, :phone_number, unique: true
  end
end
