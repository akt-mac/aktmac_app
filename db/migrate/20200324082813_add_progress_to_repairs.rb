class AddProgressToRepairs < ActiveRecord::Migration[5.2]
  def change
    add_column :repairs, :progress, 'integer USING CAST(progress AS integer)', default: 1
  end
end
