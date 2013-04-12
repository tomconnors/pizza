# admin js

define("client/admin", ["shops"], (Shops) ->

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

      Shops.insert
        name: $name.val()
        votable: $votable.is(":checked")
        votes: []

      $name.val("")
      $votable.removeAttr("checked")
)


