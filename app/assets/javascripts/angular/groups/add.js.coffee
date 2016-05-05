app.controller 'GroupAddCtrl', ['$scope', '$uibModalInstance', ($scope, $uibModalInstance)->
  $scope.group = null
  $scope.error = false

  $scope.ok = ()->
    if $scope.group == null
      $scope.error = true
      return

    $uibModalInstance.close($scope.group)

  $scope.cancel = ()->
    $uibModalInstance.close('cancel');
]
