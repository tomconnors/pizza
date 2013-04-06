# home page js
Meteor.startup () ->
  Template.home.rendered = () ->
    $pie = this.find(".pie-container")

    shops = Shops.find({votable:true}).fetch()

    scoredShops = _.map(shops, (shop) ->
      #the number of votes for this shop
      voteCount = shop.votes.length
      #the total score for this shop
      totalScore = _.reduce(shop.votes, (memo, vote) ->
        return memo + vote.score
      , 0)    

      _id: shop._id
      score: totalScore / voteCount
      name: shop.name
    ) 
   
    # allScores = _.map(shops, (shop) ->
    #   #the number of votes for this shop
    #   voteCount = shop.votes.length
    #   #the total score for this shop
    #   totalScore = _.reduce(shop.votes, (memo, vote) ->
    #     return memo + vote.score
    #   , 0)    

    #   _id: shop._id
    #   score: totalScore / voteCount
    # )

    #now we have an array with the total score for each shop.
    #reduce that to a single value
    totalScores = _.reduce(scoredShops, (memo, shop) ->
      return memo + shop.score
    , 0)

    chart = new Highcharts.Chart({
      chart:
        renderTo: $pie
        type: "pie"
      title:
        text: null
      plotOptions: {
        pie: {
          # allowPointSelect: true,
          # cursor: 'pointer',
          dataLabels: {
            enabled: true
            color: '#000000'
            connectorColor: '#000000'
            # formatter: () {
            #     return '<b>'+ this.point.name +'</b>: '+ this.percentage +' %';
            # }
          }
        }
      },
      series: [{
        type: 'pie',
        name: 'Shops',
        data: _.map(scoredShops, (shop) ->
          # voteCount = shop.votes.length
          # score = _.reduce(shop.votes, (memo, vote) ->
          #   return memo + vote.score
          # , 0)

          name: shop.name
          y: shop.score / totalScores
          sliced: false
        )
        # data: [
        #     ['Firefox',   45.0],
        #     ['IE',       26.8],
        #     {
        #         name: 'Chrome',
        #         y: 12.8,
        #         sliced: true,
        #         selected: true
        #     },
        #     ['Safari',    8.5],
        #     ['Opera',     6.2],
        #     ['Others',   0.7]
        # ]}
      }]
    })