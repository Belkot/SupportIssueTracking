class TicketNotifier < ActionMailer::Base
  default from: "Test Mailer <testrubyonrailsmailer@gmail.com>"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.ticket_notifier.received.subject
  #
  def received(ticket)
    @ticket = ticket
    @greeting = "Hi " + @ticket.name + ' !'

    mail to: @ticket.email, subject: 'Confirming your request with unique reference.'
  end

  def answer_received(answer)
    @answer = answer
    @greeting = "Hi " + @answer.ticket.name + ' !'

    mail to: @answer.ticket.email, subject: 'New answer for your ticket.'
  end
end
