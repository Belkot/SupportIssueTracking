class Answer < ActiveRecord::Base
  belongs_to :user
  belongs_to :ticket

  validates :body, presence: true, length: { in: 10..4000 }
end
