# publish collections to clients


Meteor.publish 'shops', (list_id) ->
  Shops.find( {} )