class Department < ActiveRecord::Base
  has_many :tickets

  validates :name, presence: true,  uniqueness: true, length: { in: 2..255 }
end
