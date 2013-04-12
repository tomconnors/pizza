# router

define("client/router", [], () ->
  Meteor.Router.add
    "/": ()->
      "index"    

    "/rank": () ->
      Session.set("currentShop", null)
      "rank"

    "/rank/:id": (id) ->
      Session.set("currentShop", id)
      "rank"

    "/admin": () ->
      if Meteor.user() is null        
        "index"
      else        
        "admin"
)