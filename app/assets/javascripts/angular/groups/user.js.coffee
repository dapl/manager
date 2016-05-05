app.controller 'GroupUserCtrl', ['$scope', '$uibModalInstance', 'User', ($scope, $uibModalInstance, User)->
  $scope.users = []
  $scope.selected = null
  $scope.error = false

  $scope.ok = ()->
    if $scope.selected == null
      $scope.error = true
      return

    $uibModalInstance.close($scope.selected)

  $scope.cancel = ()->
    $uibModalInstance.close('cancel');

  $scope.getUsers = ()->
    User.query().then (users)->
      $scope.users = users

  $scope.getUsers()
]
