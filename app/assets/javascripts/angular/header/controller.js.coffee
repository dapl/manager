app.controller 'HeaderCtrl', ['$scope','$location', ($scope, $location)->
  $scope.isActive = (location)->
    if location == '/'
      $location.path() == location
    else
      $location.path().indexOf(location) == 0
]
