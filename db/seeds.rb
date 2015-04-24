# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.delete_all
User.create!(email: "admin@localhost.localhost", username: "admin", password: "12345678")

Department.delete_all
Department.create!(name: "Head department")

StatusType.delete_all
StatusType.create!([
  { name: "Waiting for Staff Response" },
  { name: "Waiting for Customer" },
  { name: "On Hold" },
  { name: "Cancelled" },
  { name: "Completed" }
])

Answer.delete_all
Status.delete_all
Owner.delete_all
Ticket.delete_all
