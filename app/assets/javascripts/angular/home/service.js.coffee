app.factory 'Home', ['$resource', 'railsResourceFactory', ($resource, railsResourceFactory) ->
  return railsResourceFactory({
    url: '/home',
    name: 'home'
  });
]
