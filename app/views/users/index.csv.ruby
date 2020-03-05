require 'csv'

# CSV出力
CSV.generate do |csv|
  csv_column_names = %w(id name email)
  csv << csv_column_names
  @users_all.each do |user|
    csv_column_values = [
      user.id,
      user.name,
      user.email
    ]
    csv << csv_column_values
  end
end
