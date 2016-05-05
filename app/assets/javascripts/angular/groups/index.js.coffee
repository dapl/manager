app.controller 'GroupCtrl', ['$scope', "$location", '$uibModal', 'Group', 'Session', ($scope, $location, $uibModal, Group, Session)->
  $scope.getGroups = ()->
    Group.query({}).then (groups)->
      $scope.groups = groups

  $scope.getGroups()

  $scope.addGroup = ()->
    modalInstance = $uibModal.open({
      templateUrl: "/assets/groups/add.html",
      controller: "GroupAddCtrl",
    })
    modalInstance.result.then (group)->
      if group == 'cancel'
        console.log 'cancelled create user'
      else
        new Group({ name: group }).create().then ()->
          $scope.getGroups()
]
