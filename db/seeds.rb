# coding: utf-8

User.create!(name: "管理者",
             email: "sample@email.com",
             password: "password",
             password_confirmation: "password",
             admin: true)

15.times do |n|
  name  = Faker::Name.name
  email = "sample-#{n+1}@email.com"
  password = "password"
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password)
end

puts "Sample user creation completed!"

50.times do |n|
  reception_day = Faker::Date.between(from: 4.month.ago, to: 1.day.from_now)
  r_name = [Faker::Name.name, Faker::Company.name]
  customer_name = r_name.sample
  r_add = [Faker::Address.city, Faker::Address.street_address]
  address = "秋田市" + r_add[0] + r_add[1]
  phone_number = "018" + rand(800..899).to_s + rand(1000..9999).to_s
  mobile_phone_number = ["070", "080", "090"].sample + rand(1000..9999).to_s + rand(1000..9999).to_s
  condition = "テスト、症状#{n+1}"
end
