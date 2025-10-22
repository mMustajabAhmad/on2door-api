class CreateOrganizations < ActiveRecord::Migration[7.2]
  def up
    create_table :organizations do |t|
      t.string :name
      t.string :email, null: false
      t.string :country
      t.string :timezone
      t.integer :monthly_delivery_volume
      t.integer :primary_industry
      t.text :message

      t.timestamps
    end
  end

  def down
    drop_table :organizations
  end
end
