class MachineCategory < ApplicationRecord
  validates :code, presence: true, inclusion: {in: 1..9999 }, uniqueness: true
  validates :product, presence: true, length: { minimum: 1, maximum: 15 }

  def self.import(file)
    imported_num = 0
    
    open(file.path, 'r:cp932:utf-8', undef: :replace) do |f|
      csv = CSV.new(f, :headers => :first_row)
      csv.each do |row|
        next if row.header_row?
        table = Hash[[row.headers, row.fields].transpose]

        machine_category = find_by(id: table["id"])
        if machine_category.nil?
          machine_category = new
        end

        machine_category.attributes = table.to_hash.slice(*table.to_hash.except(:id).keys)

        if machine_category.valid?
          machine_category.save!
          imported_num += 1
        end
      end
    end
    imported_num
  end
end
