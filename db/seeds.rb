# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# default admin
User.create! :name => 'Brian Hogg', :email => 'brian@hoggworks.com', :password => 'This is a ludicrously long password that is also secure', :password_confirmation => 'This is a ludicrously long password that is also secure'

# categories
Category.create({name: "Animals", description: "" })
Category.create({name: "Arts", description: "" })
Category.create({name: "Crime", description: "" })
Category.create({name: "Economics", description: "" })
Category.create({name: "Entertainment", description: "" })
Category.create({name: "Gaming", description: "" })
Category.create({name: "Green", description: "" })
Category.create({name: "Internet", description: "" })
Category.create({name: "Film", description: "" })
Category.create({name: "Financial", description: "" })
Category.create({name: "Food", description: "" })
Category.create({name: "Fitness", description: "" })
Category.create({name: "Health", description: "" })
Category.create({name: "Investing", description: "" })
Category.create({name: "Law", description: "" })
Category.create({name: "Lifestyle", description: "" })
Category.create({name: "Local", description: "" })
Category.create({name: "Medicine", description: "" })
Category.create({name: "Military", description: "" })
Category.create({name: "Music", description: "" })
Category.create({name: "News", description: "" })
Category.create({name: "Politics", description: "" })
Category.create({name: "Parenting", description: "" })
Category.create({name: "Real Estate", description: "" })
Category.create({name: "Science", description: "" })
Category.create({name: "Social Media", description: "" })
Category.create({name: "Sports", description: "" })
Category.create({name: "Technology", description: "" })
Category.create({name: "Television", description: "" })
Category.create({name: "Travel", description: "" })