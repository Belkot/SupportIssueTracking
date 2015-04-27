class Status < ActiveRecord::Base
  belongs_to :status_type
  belongs_to :ticket
  belongs_to :user

  def set_waiting_for_staff_response(ticket)
    self.status_type = StatusType.where(name: "Waiting for Staff Response").first
    self.ticket = ticket
    self.user = nil
    self.save
  end

end
