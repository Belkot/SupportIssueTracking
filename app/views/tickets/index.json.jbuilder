json.array!(@tickets) do |ticket|
  json.extract! ticket, :id, :name, :email, :department_id, :reference, :subject
  json.url ticket_url(ticket, format: :json)
end
