class AddInitialProfileFieldsToOrganizations < ActiveRecord::Migration[7.2]
  def change
    add_column :organizations, :monthly_delivery_volume, :integer
    add_column :organizations, :primary_industry, :integer
    add_column :organizations, :message, :text
  end
end
