class Ticket < ActiveRecord::Base
  belongs_to :department
  has_many :owners
  has_many :users, through: :owners
  has_many :statuses
  has_many :status_types, through: :statuses
end
