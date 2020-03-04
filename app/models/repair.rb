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

  scope :reception_day_between, -> from, to {
    if from.present? && to.present?
      where(reception_day: from..to)
    elsif from.present?
      where('reception_day >= ?', from)
    elsif to.present?
      where('reception_day <= ?', to)
    end
  }

  scope :search, -> (search_params) do
    return if search_params.blank?

    customer_name_like(search_params[:customer_name]).
    reception_day_from((search_params[:reception_day_from].to_date)&.yesterday). # 空の値で検索するとyesterdayがnilとなりエラーになるので、&.(ぼっち演算子)でnilのエラーを返さないようにする
    reception_day_to(search_params[:reception_day_to])
  end
  scope :customer_name_like, -> (customer_name) { where('customer_name LIKE ?', "%#{customer_name}%") if customer_name.present? }
  scope :reception_day_from, -> (from) { where('? <= reception_day', from) if from.present? }
  scope :reception_day_to, -> (to) { where('reception_day <= ?', to) if to.present? }

  def self.import(file)
    imported_num = 0

    open(file.path, 'r:cp932:utf-8', undef: :replace) do |f|
      csv = CSV.new(f, :headers => :first_row)
      csv.each do |row|
        next if row.header_row?
        table = Hash[[row.headers, row.fields].transpose]

        repair = find_by(id: table["id"])
        if repair.nil?
          repair = new
        end

        repair.attributes = table.to_hash.slice(*table.to_hash.except(:id).keys)

        if repair.valid?
          repair.save!
          imported_num += 1
        end
      end
    end
    imported_num
  end

  # def self.import(file)
  #   CSV.each(file.path, headers: true) do |row|
  #     # IDが見つかれば、レコードを呼び出し、見つかれなければ、新しく作成
  #     repair = find_by(id: row["id"]) || new
  #     # CSVからデータを取得し、設定する
  #     repair.attributes = row.to_hash.slice(*updatable_attributes)
  #     repair.save
  #   end
  # end
  #
  # # 更新を許可するカラムを定義
  # def self.updatable_attributes
  #   ["reception_number",
  #    "reception_day",
  #    "customer_name",
  #    "address",
  #    "phone_number",
  #    "mobile_phone_number",
  #    "machine_model",
  #    "category",
  #    "condition",
  #    "note",
  #    "progress",
  #    "contacted",
  #    "delivery",
  #    "reminder",
  #    "repair_staff",
  #    "completed"]
  # end
end
