app.controller 'UserCtrl', ['$scope', "$location", '$uibModal', 'User', 'Session', ($scope, $location, $uibModal, User, Session)->
  $scope.isAdmin = Session.admin()

  $scope.addUser = ()->
    modalInstance = $uibModal.open({
      templateUrl: "/assets/users/add.html",
      controller: "UserAddCtrl",
#      resolve:
#        user: ()->
#          $scope.user
    })
    modalInstance.result.then (user)->
      if user == 'cancel'
        console.log 'cancelled create user'
      else
        console.debug user
        new User({
          login: user.login,
          first_name: user.first_name,
          last_name: user.last_name,
          key: user.key
        }).create().then ()->
          $scope.getUsers()

  $scope.getUsers = ()->
    User.query({}).then (users)->
      $scope.users = users
  $scope.getUsers()
]
