class StatusType < ActiveRecord::Base
  has_many :statuses
  has_many :tickets, through: :statuses
end
