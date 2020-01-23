class CreateMachineCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :machine_categories do |t|
      t.integer :code, unique: true
      t.string :product

      t.timestamps
    end
  end
end
