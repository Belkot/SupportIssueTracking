# Preview all emails at http://localhost:3000/rails/mailers/ticket_notifier
class TicketNotifierPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/ticket_notifier/received
  def received
    TicketNotifier.received
  end

end
