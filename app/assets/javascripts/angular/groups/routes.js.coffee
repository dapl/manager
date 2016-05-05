app.config ['$routeProvider', ($routeProvider) ->
  $routeProvider
  .when "/groups",
    templateUrl: "/assets/groups/index.html"
  .when "/groups/:id",
    templateUrl: "/assets/groups/show.html"
]
