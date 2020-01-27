class AddDefaultProgressToRepairs < ActiveRecord::Migration[5.2]
  def change
    change_column :repairs, :progress, :integer, default: 1
  end
end
