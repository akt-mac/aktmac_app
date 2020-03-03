class AddIndexToRepairsReceptionNumber < ActiveRecord::Migration[5.2]
  def change
    add_index :repairs, :reception_number, unique: true
  end
end
