Meteor.methods(
  updateScore: (currentShop, score) ->

    console.log("update score", currentShop, score)

    if currentShop?       

      query = 
        _id: currentShop
        "votes.user": this.userId      

      #todo: this is unvalidated!
      if Shops.find(query).fetch().length

        console.log("its there already")
        Shops.update
          _id: currentShop
          "votes.user": this.userId
        ,
          $set:
            "votes.$.score": score
        

      else
        console.log("not there already")
        Shops.update
          _id: currentShop
        ,
          $push:
            votes:
              user: this.userId
              score: score
)



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

Meteor.publish 'shops', (list_id) ->
  Shops.find( {} )