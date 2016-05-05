app.controller 'UserPasswordCtrl', ['$scope', '$uibModalInstance', ($scope, $uibModalInstance)->
  $scope.password = null
  $scope.confirmation = null
  $scope.error = false

  $scope.ok = ()->
    if $scope.password == null || $scope.confirmation == null || $scope.password != $scope.confirmation
      $scope.error = true
      return

    $uibModalInstance.close({password: $scope.password, confirmation: $scope.confirmation})

  $scope.cancel = ()->
    $uibModalInstance.close('cancel');
]
