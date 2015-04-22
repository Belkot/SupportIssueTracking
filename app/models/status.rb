class Status < ActiveRecord::Base
  belongs_to :status_type
  belongs_to :ticket
  belongs_to :user
end
