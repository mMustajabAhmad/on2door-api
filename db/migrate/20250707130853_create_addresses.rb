class CreateAddresses < ActiveRecord::Migration[7.2]
  def up
    create_table :addresses do |t|
      t.string :name
      t.string :street
      t.integer :street_number
      t.string :city
      t.string :state
      t.string :country
      t.string :postal_code
      t.integer :appartment
      t.float :latitude
      t.float :longitude

      t.references :addressable, polymorphic: true, null: false
      t.timestamps
    end
  end

  def down
    drop_table :addresses
  end
end
