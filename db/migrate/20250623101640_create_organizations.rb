class CreateOrganizations < ActiveRecord::Migration[7.1]
  def change
    create_table :organizations do |t|
      t.string :name
      t.string :email, null: false
      t.string :country
      t.string :timezone

      t.timestamps
    end
    
    add_index :organizations, :email, unique: true
  end
end
