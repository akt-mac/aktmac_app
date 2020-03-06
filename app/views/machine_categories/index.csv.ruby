require 'csv'

# CSV出力
CSV.generate do |csv|
  csv_column_names = %w(id code product)
  csv << csv_column_names
  @machine_categories_all.each do |m|
    csv_column_values = [
      m.id,
      m.code,
      m.product
    ]
    csv << csv_column_values
  end
end
