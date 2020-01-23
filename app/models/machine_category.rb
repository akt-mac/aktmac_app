class MachineCategory < ApplicationRecord
  validates :code, presence: true, length: { maximum: 1000 }, uniqueness: true
  validates :product, presence: true, length: { maximum: 20 }
end
