class CreateHubs < ActiveRecord::Migration[7.2]
  def up
    create_table :hubs do |t|
      t.string :name

      t.timestamps
    end
  end

  def down
    drop_table :hubs
  end
end
