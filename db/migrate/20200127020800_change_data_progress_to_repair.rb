class ChangeDataProgressToRepair < ActiveRecord::Migration[5.2]
  def change
    change_column :repairs, :progress, :integer
  end
end
