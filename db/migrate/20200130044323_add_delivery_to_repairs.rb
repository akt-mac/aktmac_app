class AddDeliveryToRepairs < ActiveRecord::Migration[5.2]
  def change
    add_column :repairs, :delivery, :integer, default: 1
  end
end
