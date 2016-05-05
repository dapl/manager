app.controller 'HomeCtrl', ['$scope', "$location", 'User', 'Session', ($scope, $location, User, Session)->
#  User.get('me').then (user)->
#    $scope.user = user
#    $scope.me = $scope.user && $scope.user.login == Session.current().login
#    $scope.admin = Session.admin()
#    console.log "scope: #{$scope.user} #{$scope.me} #{$scope.admin}"
]
