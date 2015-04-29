class StatusType < ActiveRecord::Base
  has_many :statuses
  has_many :tickets, through: :statuses

  validates :name, presence: true,  uniqueness: true, length: { in: 2..255 }
end
