# publish collections to clients
define("server/publish", ["shops"], (Shops)->

  Meteor.publish 'shops', (list_id) ->
    Shops.find( {} )

)