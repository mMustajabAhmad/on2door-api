class CreateRecipients < ActiveRecord::Migration[7.1]
  def change
    create_table :recipients do |t|
      t.string :name
      t.string :phone_number
      t.string :notes
      t.boolean :skip_sms_notification

      t.timestamps
    end
  end
end
