# meteor methods

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