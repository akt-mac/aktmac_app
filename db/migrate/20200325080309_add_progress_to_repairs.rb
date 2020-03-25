class AddProgressToRepairs < ActiveRecord::Migration[5.2]
  def change
    add_column :repairs, :category, :string
    add_column :repairs, :progress, :integer, default: 1
    add_column :repairs, :repair_staff, :string
    add_column :repairs, :completed, :datetime
  end
end
