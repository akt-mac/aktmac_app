class Repair < ApplicationRecord
  validates :reception_day, presence: true
  validates :customer_name, presence: true, length: { maximum: 50 }
  validates :phone_number, format: { with: /\A\d{10}\z/ }, allow_blank: true
  validates :mobile_phone_number, format: { with: /\A\d{10,11}\z/ }, allow_blank: true
  validates :machine_model, length: { maximum: 30 }
  validates :condition, length: { maximum: 500 }
  validates :category, length: { maximum: 30 }
  validates :progress, length: { maximum: 10 }
  validates :repair_staff, length: { maximum: 50 }
  validates :note, length: { maximum: 500 }
  validates :repair_staff, length: { maximum: 50 }
end
