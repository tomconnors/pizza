# populate database

Meteor.startup () -> 
  if Shops.find().count() is 0
    data = [
        name: "Chris's Pizza"
        votable: true
        votes: []
      ,
        name: "Las Vegas Pizza"
        votable: true
        votes: []          
    ]

    #Shops.remove({})

    _.each data, (shop, index, list) ->
      Shops.insert shop