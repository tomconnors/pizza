# home page js

define("client/home", ["shops", "client/router"], (Shops) ->

  Highcharts.setOptions({
    colors: [
      "#FF0000"
      "#BF3030"
      "#A60000"
      "#FF4040"
      "#FF7373"
      "#FF8E00"
      "#BF8030"
      "#A65C00"
      "#FFAA40"
      "#FFC173"
      "#FFB600"
      "#BF9630"
      "#A67600"
      "#FFC840"
      "#FFD773"
      "#FFF100"
      "#FFF440"
      "#FF6700"
      "#FF8D40"
      "#FFAB73"
    ]
  })

  Template.index.rendered = () ->
    self = @

    #need deps.autorun so the pie chart will re-render whenever 
    #shops changes
    Deps.autorun( ()->
      $pie = self.find(".pie-container")

      shops = Shops.find({votable:true}).fetch()

      if shops

        
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
              dataLabels: {
                enabled: true
                color: '#000000'
                connectorColor: '#000000'
                formatter: () ->
                  '<b>' + this.key + '</b>: ' + this.y            
              }
            }
          },
          series: [{
            type: 'pie',
            name: 'Shops',
            data: _.map(scoredShops, (shop) ->
              name: shop.name
              y: if shop.score then parseFloat( ( (shop.score / totalScores) * 100).toFixed(2) ) else 0
              sliced: false
            )
          }]
        })
     
    )
)