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
Category.create({name: "Alternative Medicine", description: ""})
Category.create({name: "Animals", description: "" })
Category.create({name: "Arts", description: "" })
Category.create({name: "Botany", description: ""})
Category.create({name: "Conspiracy Theories", description: ""})
Category.create({name: "Crime", description: "" })
Category.create({name: "Cryptozooology", description: ""})
Category.create({name: "Death", description: ""})
Category.create({name: "Diet", description: ""})
Category.create({name: "Ecology", description: ""})
Category.create({name: "Economics", description: "" })
Category.create({name: "Entertainment", description: "" })
Category.create({name: "Gaming", description: "" })
Category.create({name: "Green", description: "" })
Category.create({name: "Internet", description: "" })
Category.create({name: "Film", description: "" })
Category.create({name: "Financial", description: "" })
Category.create({name: "Fitness", description: "" })
Category.create({name: "Food", description: "" })
Category.create({name: "Fringe Science", description: ""})
Category.create({name: "Futurism", description: ""})
Category.create({name: "Ghosts", description: ""})
Category.create({name: "GMO", description: ""})
Category.create({name: "Health", description: "" })
Category.create({name: "History", description: ""})
Category.create({name: "Investing", description: "" })
Category.create({name: "Law", description: "" })
Category.create({name: "Lifestyle", description: "" })
Category.create({name: "Local", description: "" })
Category.create({name: "Medicine", description: "" })
Category.create({name: "Military", description: "" })
Category.create({name: "Music", description: "" })
Category.create({name: "News", description: "" })
Category.create({name: "Politics", description: "" })
Category.create({name: "Psychic Phenomena", description: ""})
Category.create({name: "Psychology", description: ""})
Category.create({name: "Parenting", description: "" })
Category.create({name: "Real Estate", description: "" })
Category.create({name: "Religion", description: ""})
Category.create({name: "Science", description: "" })
Category.create({name: "Social Media", description: "" })
Category.create({name: "Social Justice", description: ""})
Category.create({name: "Sociology", description: ""})
Category.create({name: "Spiritualism", description: ""})
Category.create({name: "Sports", description: "" })
Category.create({name: "Supernatural", description: ""})
Category.create({name: "Technology", description: "" })
Category.create({name: "Television", description: "" })
Category.create({name: "Travel", description: "" })
Category.create({name: "Vaccinations", description: ""})