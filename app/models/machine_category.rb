class MachineCategory < ApplicationRecord
  validates :code, presence: true, inclusion: {in: 1..9999 }, uniqueness: true
  validates :product, presence: true, length: { minimum: 1, maximum: 15 }
end
