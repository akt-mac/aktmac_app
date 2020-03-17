class AddDeleteCheckToRepairs < ActiveRecord::Migration[5.2]
  def change
    add_column :repairs, :delete_check, :string
  end
end
