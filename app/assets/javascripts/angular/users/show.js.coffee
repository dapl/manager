app.controller 'UserShowCtrl', ['$scope', "$location", '$routeParams', '$uibModal', 'User', 'Session', ($scope, $location, $routeParams, $uibModal, User, Session)->
  $scope.disable = ()->
    User.disable($scope.user.login).then ()->
      $scope.getUser()

  $scope.enable = ()->
    User.enable($scope.user.login).then ()->
      $scope.getUser()

  $scope.updateName = (data)->
    $scope.user.name = data.name
    $scope.user.save()

  $scope.updateEmail = (data)->
    $scope.user.email = data.email
    $scope.user.save()

  $scope.changePassword = ()->
    modalInstance = $uibModal.open({
      templateUrl: "/assets/users/password.html",
      controller: "UserPasswordCtrl",
    })
    modalInstance.result.then (data)->
      if data == 'cancel'
        console.log 'cancelled change password'
      else
        User.passwordChange($scope.user.login, data.password, data.confirmation).then ()->
          $scope.getUser()

  $scope.addGroup = ()->
    modalInstance = $uibModal.open({
      templateUrl: "/assets/users/group.html",
      controller: "UserGroupCtrl",
    })
    modalInstance.result.then (group)->
      if group == 'cancel'
        console.log 'cancelled add group'
      else
        console.debug group
        User.groupAdd($scope.user.login, group).then ()->
          $scope.getUser()

  $scope.removeGroup = (group)->
    $scope.user.groups = $scope.user.groups.filter (g) -> g isnt group
    User.groupRemove($scope.user.login, group).then ()->
      $scope.getUser()

  $scope.addKey = ()->
    modalInstance = $uibModal.open({
      templateUrl: "/assets/users/key.html",
      controller: "UserKeyCtrl",
    })
    modalInstance.result.then (key)->
      if key == 'cancel'
        console.log 'cancelled add key'
      else
        console.debug key
        User.keyAdd($scope.user.login, key).then ()->
          $scope.getUser()

  $scope.removeKey = (key)->
    $scope.user.keys = $scope.user.keys.filter (k) -> k isnt key
    User.keyRemove($scope.user.login, key).then ()->
      $scope.getUser()

  $scope.getUser = ()->
    User.get($routeParams.id).then (user)->
      $scope.user = user
      $scope.isMe = user && user.login == Session.current().login
      $scope.isAdmin = Session.admin()
  $scope.getUser()
]
