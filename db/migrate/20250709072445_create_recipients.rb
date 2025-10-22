class CreateRecipients < ActiveRecord::Migration[7.2]
  def up
    create_table :recipients do |t|
      t.string :name
      t.string :phone_number
      t.boolean :skip_sms_notification

      t.timestamps
    end
  end

  def down
    drop_table :recipients
  end
end
