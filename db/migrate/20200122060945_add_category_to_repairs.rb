class AddCategoryToRepairs < ActiveRecord::Migration[5.2]
  def change
    add_column :repairs, :category, :string
    add_column :repairs, :progress, :integer
    add_column :repairs, :repair_staff, :string
    add_column :repairs, :completed, :datetime
  end
end
