class MachineCategory < ApplicationRecord
  validates :code, presence: true, length: { maximum: 1000 }
  validates :product, presence: true, length: { maximum: 20 }, uniqueness: true
end
