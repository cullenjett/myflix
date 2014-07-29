# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.delete_all
Category.delete_all
Video.delete_all
Review.delete_all
QueueItem.delete_all
Invitation.delete_all
Relationship.delete_all

cullen = User.create(email: "cullenjett@gmail.com", password: "password", name: "Cullen Jett", admin: true)

drama = Category.create(name: "Drama")
comedy = Category.create(name: "Comedy")
action = Category.create(name: "Action")
