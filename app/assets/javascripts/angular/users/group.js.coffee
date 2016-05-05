app.controller 'UserGroupCtrl', ['$scope', '$uibModalInstance', 'Group', ($scope, $uibModalInstance, Group)->
  $scope.groups = []
  $scope.selected = null
  $scope.error = false

  $scope.ok = ()->
    if $scope.selected == null
      $scope.error = true
      return

    $uibModalInstance.close($scope.selected)

  $scope.cancel = ()->
    $uibModalInstance.close('cancel');

  $scope.getGroups = ()->
    Group.query().then (groups)->
      $scope.groups = groups
  $scope.getGroups()
]
