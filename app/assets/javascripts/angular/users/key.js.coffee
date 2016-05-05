app.controller 'UserKeyCtrl', ['$scope', '$uibModalInstance', ($scope, $uibModalInstance)->
  $scope.key = null

  $scope.ok = ()->
    if $scope.key == null
      $scope.error = true
      return

    $uibModalInstance.close($scope.key)

  $scope.cancel = ()->
    $uibModalInstance.close('cancel');
]
