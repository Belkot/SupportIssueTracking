class TicketNotifier < ActionMailer::Base
  default from: "Test Mailer <testrubyonrailsmailer@gmail.com>"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.ticket_notifier.received.subject
  #
  def received(ticket)
    @ticket = ticket
    @greeting = "Hi " + @ticket.name

    mail to: @ticket.email, subject: 'Confirming your request with unique reference.'
  end
end
