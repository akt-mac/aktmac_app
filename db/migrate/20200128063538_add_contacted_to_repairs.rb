class AddContactedToRepairs < ActiveRecord::Migration[5.2]
  def change
    add_column :repairs, :contacted, :integer, default: 1
  end
end
