class Repair < ApplicationRecord
  validates :reception_day, presence: true
  validates :customer_name, presence: true, length: { maximum: 50 }
  validates :address, length: { maximum: 100 }
  validates :phone_number, format: { with: /\A\d{10}\z/ }, allow_blank: true
  validates :mobile_phone_number, format: { with: /\A\d{10,11}\z/ }, allow_blank: true
  validates :machine_model, length: { maximum: 30 }
  validates :condition, length: { maximum: 500 }
  validates :category, length: { maximum: 30 }
  validates :progress,presence: true, length: { maximum: 1 }
  validates :repair_staff, length: { maximum: 50 }
  validates :note, length: { maximum: 500 }
  validates :repair_staff, length: { maximum: 50 }
  validates :contacted, presence: true, length: { maximum: 1 }
  validates :delivery, presence: true, length: { maximum: 1 }
  validates :reminder, presence: true, length: { maximum: 1 }

  # def self.search(search)
  #   return Repair.all unless search
  #   Repair.where(['customer_name LIKE ? OR machine_model LIKE ?', "%#{search}%", "%#{search}%"])
  # end

  scope :search, -> (search_params) do
    return if search_params.blank?

    customer_name_like(search_params[:customer_name])
      .reception_day_from(search_params[:reception_day_from])
      .reception_day_to(search_params[:reception_day_to])
  end
  scope :customer_name_like, -> (customer_name) { where('customer_name LIKE ?', "%#{customer_name}%") if customer_name.present? }
  scope :reception_day_from, -> (from) { where('? <= reception_day', from) if from.present? }
  scope :reception_day_to, -> (to) { where('reception_day <= ?', to) if to.present? }
end
