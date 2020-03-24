class ChangeProgressToRepairs < ActiveRecord::Migration[5.2]
  def up
    # 環境ごとにマイグレーションを分ける
    if Rails.env.development? || Rails.env.test?
      change_column :repairs, :progress, :integer, default: 1
    else Rails.env.production?
      # 本番環境はusingオプションを追加
      change_column :repairs, :progress, 'integer USING CAST(progress AS integer)', default: 1
    end
  end

  def down
    change_column :repairs, :progress, :integer, default: 1
  end
end
