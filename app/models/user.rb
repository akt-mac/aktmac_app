class User < ApplicationRecord
  attr_accessor :remember_token
  before_save { self.email = email.downcase }

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
                    length: { maximum: 100 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true
  has_secure_password
  validates :password, presence: true, length: { minimum: 4 }, allow_nil: true

  def User.digest(string)
    cost =
      if ActiveModel::SecurePassword.min_cost
        BCrypt::Engine::MIN_COST
      else
        BCrypt::Engine.cost
      end
    BCrypt::Password.create(string, cost: cost)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def self.import(file)
    imported_num = 0

    open(file.path, 'r:cp932:utf-8', undef: :replace) do |f|
      csv = CSV.new(f, :headers => :first_row)
      begin
        csv.each do |row|
          next if row.header_row?
          table = Hash[[row.headers, row.fields].transpose]

          user = find_by(id: table["id"])
          if user.nil?
            user = new
          end

          user.attributes = table.to_hash.slice(*table.to_hash.except(:id).keys)

          if user.valid?
            user.save!
            imported_num += 1
          end
        end
      rescue
      end
    end
    imported_num
  end
end
