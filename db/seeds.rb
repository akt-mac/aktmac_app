# coding: utf-8

User.create!(name: "管理者",
             email: "sample@email.com",
             password: "password",
             password_confirmation: "password",
             admin: true,
             editor: true)

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

MachineCategory.create!(
  [
    {code: 1, product: "チェンソー"},
    {code: 2, product: "チェーン目立"},
    {code: 3, product: "刈払機"},
    {code: 4, product: "モア"},
    {code: 5, product: "除雪機"},
    {code: 99, product: "その他"}
  ]
)

puts "Sample machine_category creation completed!"

50.times do |n|
  reception_day = Faker::Date.between(from: 4.month.ago, to: 1.day.from_now)
  r_name = [Faker::Name.name, Faker::Company.name]
  customer_name = r_name.sample
  r_add = [Faker::Address.city, Faker::Address.street_address]
  address = "秋田市" + r_add[0] + r_add[1]
  phone_number = "018" + rand(800..899).to_s + rand(1000..9999).to_s
  mobile_phone_number = ["070", "080", "090"].sample + rand(1000..9999).to_s + rand(1000..9999).to_s
  machine_model = Faker::Types.character.upcase + Faker::Types.character.upcase + Faker::Number.between(from: 330, to: 580).to_s
  condition = "症状#{n+1}。テスト、" + Faker::Lorem.sentence
  category = ["チェンソー", "刈払機", "モア", "薪割機", "除雪機", "その他"].sample
  progress = 1
  repair_staff = Faker::Name.name
  note = "備考#{n+1}。テスト、" + Faker::Lorem.sentence
  reception_number = n + 100
  Repair.create!(reception_day: reception_day,
                 customer_name: customer_name,
                 address: address,
                 phone_number: phone_number,
                 mobile_phone_number: mobile_phone_number,
                 machine_model: machine_model,
                 condition: condition,
                 category: category,
                 progress: progress,
                 repair_staff: repair_staff,
                 note: note,
                 reception_number: reception_number)
end

puts "Sample repair creation completed!"
