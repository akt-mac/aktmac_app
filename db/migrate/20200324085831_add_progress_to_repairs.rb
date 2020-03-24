class AddProgressToRepairs < ActiveRecord::Migration[5.2]
  # def change
  #   add_column :repairs, :progress, :integer, default: 1
  # end
  def up
    # 環境ごとにマイグレーションを分ける
    if Rails.env.development? || Rails.env.test?
      change_column :repairs_url, :progress, :integer
    else Rails.env.production?
      # 本番環境はusingオプションを追加
      change_column :repairs, :progress, 'progress USING CAST(integer AS progress)'
    end
  end

  def down
    change_column :repairs, :progress, :integer
  end
end
