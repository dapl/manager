app.controller 'GroupShowCtrl', ['$scope', "$location", '$routeParams', '$uibModal', 'Group', 'Session',
  ($scope, $location, $routeParams, $uibModal, Group, Session)->
    $scope.getGroup = ()->
      Group.get($routeParams.id).then (group)->
        $scope.group = group
        $scope.isAdmin = Session.admin()
    $scope.getGroup()

    $scope.destroy = ()->
      $scope.group.delete().then ()->
        $location.path("/groups")

    $scope.addUser = ()->
      modalInstance = $uibModal.open({
        templateUrl: "/assets/groups/user.html",
        controller: "GroupUserCtrl",
      })
      modalInstance.result.then (user)->
        if user == 'cancel'
          console.log 'cancelled add user'
        else
          console.debug user
          Group.userAdd($scope.group.name, user).then ()->
            $scope.getGroup()

    $scope.removeUser = (user)->
      Group.userRemove($scope.group.name, user).then ()->
        $scope.getGroup()
]
