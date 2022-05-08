class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # 投稿数
  scope :created_ndays_ago, ->(n) { where(created_at: n.day.ago.all_day) }
  scope :created_this_week, -> { where(created_at: 6.day.ago.beginning_of_day..Time.zone.now.end_of_day) }
  scope :created_last_week, -> { where(created_at: 2.week.ago.beginning_of_day..1.week.ago.end_of_day) }
end
