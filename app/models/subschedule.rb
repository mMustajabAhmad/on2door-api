class Subschedule < ApplicationRecord
  belongs_to :schedule

  validates :shift_start, presence: true
  validates :shift_end, presence: true
  validate :shift_end_after_shift_start

  def self.ransackable_attributes(auth_object = nil)
    ["id", "shift_start", "shift_end", "schedule_id", "created_at", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["schedule"]
  end

  private

  def shift_end_after_shift_start
    return unless shift_start && shift_end

    if shift_end <= shift_start
      errors.add(:shift_end, "must be after shift start")
    end
  end
end
