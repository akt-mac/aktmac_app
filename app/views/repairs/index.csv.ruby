require 'csv'

# CSV出力
CSV.generate do |csv|
  csv_column_names = %w(reception_number reception_day customer_name address
                        phone_number mobile_phone_number machine_model category
                        condition note progress contacted delivery reminder repair_staff completed)
  csv << csv_column_names
  @repairs.each do |r|
    csv_column_values = [
      r.reception_number,
      r.reception_day,
      r.customer_name,
      r.address,
      r.phone_number,
      r.mobile_phone_number,
      r.machine_model,
      r.category,
      r.condition,
      r.note,
      r.progress,
      r.contacted,
      r.delivery,
      r.reminder,
      r.repair_staff,
      r.completed
    ]
    csv << csv_column_values
  end
end
