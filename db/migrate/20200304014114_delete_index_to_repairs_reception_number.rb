class DeleteIndexToRepairsReceptionNumber < ActiveRecord::Migration[5.2]
  def change
    remove_index :repairs, :reception_number
  end
end
