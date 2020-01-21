class CreateRepairs < ActiveRecord::Migration[5.2]
  def change
    create_table :repairs do |t|
      t.datetime :reception_day
      t.string :customer_name
      t.string :address
      t.string :phone_number
      t.string :mobile_phone_number
      t.string :machine_model
      t.string :condition

      t.timestamps
    end
  end
end
