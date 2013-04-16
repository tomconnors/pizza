define("client/menu", ["shops", "client/router"], (Shops) ->
  Template.menu.currentUserIsAdmin = ()->
    Meteor.userId() is "QanYCFMt5e968LAyL"
)