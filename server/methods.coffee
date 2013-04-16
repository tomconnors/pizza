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

    unrank:(shop) ->
      Shops.update({_id: shop}, {$pull: {votes: {user: this.userId}}})
  )

  ADMINS = ['v69kN7mDT9Wsk439X']

  Shops.allow(
    insert: (userId, doc)->
      true #for now, anyone can insert
    remove: (userId, doc)->
      true #same

    update: (userId, doc, fieldNames, modifier)->
      #use cases: 
      # update shop name
      # update shop votability      
      #to update name or votability, you must be me
      if ( _.contains(fieldNames, "votable") or _.contains(fieldNames, "name") ) and fieldNames.length == 1
        _.contains(ADMINS, userId)
      else 
        false      
  )
)