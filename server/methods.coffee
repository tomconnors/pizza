# meteor methods
define("server/methods", ["shops"], (Shops)->
  Meteor.methods(
    updateScore: (currentShop, score) ->    

      if currentShop and this.userId       

        query = 
          _id: currentShop
          "votes.user": this.userId      

        #todo: this is unvalidated!
        if Shops.find(query).fetch().length
          Shops.update
            _id: currentShop
            "votes.user": this.userId
          ,
            $set:
              "votes.$.score": score
          

        else
          Shops.update
            _id: currentShop
          ,
            $push:
              votes:
                user: this.userId
                score: score
  )
)