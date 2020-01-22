class AddNoteToRepairs < ActiveRecord::Migration[5.2]
  def change
    add_column :repairs, :note, :string
  end
end
