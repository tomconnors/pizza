# rank template js
define("client/rank", ["shops"], (Shops) ->


  Template.rank.currentShop = () ->
    id = Session.get("currentShop")
    if id
      Shops.findOne({_id: id}).name        
    else
      "Pick a Shop"

  Template.rank.score = () -> 
    id = Session.get("currentShop")    
    if id
      _.where( Shops.findOne({_id: id}).votes, {user: Meteor.userId()} )[0]?.score ? 0
    else
      0

  Template.rankedShop.score = () ->
    user = Meteor.userId()
    _.first( _.where(@.votes, {user:user}) )?.score ? 0


  Template.rank.rankedShops = () ->
    query = 
      votable: true
      "votes.user": Meteor.userId()

    projection =       
      name: 1      

    Shops.find query    


  Template.rank.unrankedShops = ()->

    #shit, this query was tough to figure out.
    #is there an easier way?
    query = 
      votable: true
      "votes":
        $not:
          $elemMatch:
            "user": Meteor.userId()


    projection =
      votes: 0

    Shops.find query, projection

  Template.rank.events = 
    "click button[name=unrank]": (event) ->
      #delete the vote for the current shop for this user
      selector = 
        _id: Session.get("currentShop")
        #"votes.user": Meteor.user()

      update = 
        $pull:
          votes:
            user: Meteor.userId()

      Shops.update selector, update

      #navigate to the `rank` route (with no shop)
      Meteor.Router.to('/rank');

    "change input[name=score]": (event) ->
      #update the value in the shops collection for the vote for 
      # this shop and this user to the current value of the input
      score = parseInt( $(event.target).val(), 10)
      currentShop = Session.get("currentShop")

      Meteor.call("updateScore", currentShop, score)
)
       