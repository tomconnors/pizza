Shops = new Meteor.Collection("shops")

if Meteor.isClient

  Meteor.subscribe("shops")

  Meteor.startup () ->
    #$(".content").html( Meteor.render(Template.render) )

  Meteor.Router.add
    "/": "home"

    "/rank": () ->
      Session.set("currentShop", null)
      "rank"

    "/rank/:id": (id) ->
      console.log("here")
      Session.set("currentShop", id)
      "rank"

    "/admin": () ->
      if Meteor.user() is null        
        "home"
      else        
        "admin"

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
    console.log("score", @)
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
    query = 
      votable: true
      "votes.user": 
        $not: Meteor.userId()

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

      if currentShop?       

        query = 
          _id: currentShop
          "votes.user": Meteor.userId()      

        #todo: this is unvalidated!
        if Shops.find(query).fetch().length

          Shops.update(
            _id: currentShop
            "votes.user": Meteor.userId()
          ,
            $set:
              "votes.$.score": score
          )

        else
          Shops.update
            _id: currentShop
          ,
            $push:
              votes:
                user: Meteor.userId()
                score: score
         



  # Template.rank.rendered = () ->
  #   slide = this.find(".slide")
  #   $slide = $(slide)
  #   $document = $(document)

  #   startLeft = null
  #   $slideLeft = null

  #   $slide.on("mousedown", (event)->
  #     console.log("mousedown")
  #     startLeft = event.screenX
  #     $slideLeft = $slide.css("left")
  #     $(document).on("mousemove", drag)
  #     # $document.on("mouseup", ()->
  #     #   $document.off("mousemove")
  #     # )
  #   )

  #   removeEvents = () ->
  #     $document.off("mouseup", drag)
  #     $document.off("mousemove", removeEvents)

  #   $document.on("mouseup", (event) ->
  #     console.log("mouseup")
  #     $(document).off("mousemove", drag)
  #   )

  #   drag = (event)->
  #     console.log("drag")
  #     newLeft = event.screenX
  #     $slide.css("left", $slideLeft + (newLeft - startLeft))
  #   #top = $slide.css("top")

  #   #$slide.on("drag", ()->
  #   #  this.css("top", top)
  #   #)
      
         



      

  Template.admin.shops = () ->
    return Shops.find({})

  Template.admin.events = 

    #when the shops name is changed in the input, update the db.
    "change input[type=text]": (event) ->
      Shops.update( 
        _id: @._id
      ,
        $set:
          name: $(event.target).val()
      )

    "change input[type=checkbox]": (event) ->
      Shops.update(
        _id: @._id
      ,
        $set:
          votable: $(event.target).is(":checked")
      )

    "click .delete": (event) ->
      if confirm("You sure?")
        Shops.remove(@._id)

    "click .add": (event) ->
      $name = $("#shop-add-name")
      $votable = $("#shop-add-votable")

      #console.log($votable.is(":checked"))

      Shops.insert
        name: $name.val()
        votable: $votable.is(":checked")
        votes: []

      $name.val("")
      $votable.removeAttr("checked")





if (Meteor.isServer) 
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

