class RemoveProgressToRepairs < ActiveRecord::Migration[5.2]
  def change
    remove_column :repairs, :progress, :integer
  end
end
