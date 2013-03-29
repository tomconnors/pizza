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
      console.log(Shops)
      console.log(Shops.findOne({_id: id}))
      Shops.findOne({_id: id}).name        
    else
      "Pick a Shop"

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

  Template.rank.rendered = () ->
    slide = this.find(".slide")
    $slide = $(slide)
    $document = $(document)

    startLeft = null
    $slideLeft = null

    $slide.on("mousedown", (event)->
      console.log("mousedown")
      startLeft = event.screenX
      $slideLeft = $slide.css("left")
      $(document).on("mousemove", drag)
      # $document.on("mouseup", ()->
      #   $document.off("mousemove")
      # )
    )

    removeEvents = () ->
      $document.off("mouseup", drag)
      $document.off("mousemove", removeEvents)

    $document.on("mouseup", (event) ->
      console.log("mouseup")
      $(document).off("mousemove", drag)
    )

    drag = (event)->
      console.log("drag")
      newLeft = event.screenX
      $slide.css("left", $slideLeft + (newLeft - startLeft))
    #top = $slide.css("top")

    #$slide.on("drag", ()->
    #  this.css("top", top)
    #)
      
         



      

  Template.admin.shops = () ->
    return Shops.find({})

  Template.admin.events = 

    #when the shops name is changed in the input, update the db.
    "change input[type=text]": (event) ->
      Shops.update( 
        _id: this._id
      ,
        $set:
          name: $(event.target).val()
      )

    "change input[type=checkbox]": (event) ->
      Shops.update(
        _id: this._id
      ,
        $set:
          votable: $(event.target).is(":checked")
      )

    "click .delete": (event) ->
      if confirm("You sure?")
        Shops.remove(this._id)

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

