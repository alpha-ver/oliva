# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

a=User.new(:email => "hav0k@me.com", :password => "kjkjirf", :role_id => 1024)
a.save
a.confirm!

Role.create([
  {:id => -1,   :name => "Banned" },
  {:id => 1024, :name => "Admin"  },
  {:id => 1,    :name => "Free"   }
])


Vk::Account.create({
  :id=>250673877, :token=>"86f762a35144e437470d7060579dc5e83955b09122296a5e6c37a38901ac6065b0b43e613a5b29abdb970", :status => 1024
})


