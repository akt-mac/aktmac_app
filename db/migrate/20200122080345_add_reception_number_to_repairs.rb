class AddReceptionNumberToRepairs < ActiveRecord::Migration[5.2]
  def change
    add_column :repairs, :reception_number, :integer
  end
end
