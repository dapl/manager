app.config ['$routeProvider', ($routeProvider) ->
  $routeProvider
  .when "/users",
    templateUrl: "/assets/users/index.html"
  .when "/users/:id",
    templateUrl: "/assets/users/show.html"
]
