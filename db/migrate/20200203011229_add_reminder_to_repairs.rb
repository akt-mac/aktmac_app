class AddReminderToRepairs < ActiveRecord::Migration[5.2]
  def change
    add_column :repairs, :reminder, :integer, default: 1
  end
end
