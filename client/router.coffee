# router

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